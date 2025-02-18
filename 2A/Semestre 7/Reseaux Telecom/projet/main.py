from random import randint
import random
import simpy
import networkx as nx
import matplotlib.pyplot as plt
import numpy.random as np

MACHINES_NUMBER = 5
CA_NUMBER = 3


# For the congestion matrix we have :
#       CA1     CA2     CA3    CTS1    CTS2
# CA1   0       10      0      100     100
# CA2   0       0       10     100     100
# CA3   10      10      10     100     100
# CTS1  100     100     100    0       1000
# CTS2  100     100     100    1000    0
CONGESTION_MATRIX = [[0, 10, 0, 100, 100],
                     [10, 0, 10, 100, 100],
                     [0, 10, 0, 100, 100],
                     [100, 100, 100, 0, 1000],
                     [100, 100, 100, 1000, 0]]

capacity = [[0, 10, 0, 100, 100],
            [10, 0, 10, 100, 100],
            [0, 10, 0, 100, 100],
            [100, 100, 100, 0, 1000],
            [100, 100, 100, 1000, 0]]


network = nx.Graph()
network.add_node('CA1')
network.add_node('CA2')
network.add_node('CA3')
network.add_node('CTS1')
network.add_node('CTS2')

list_edge = [('CA1', 'CA2'), ('CA1', 'CTS1'), ('CA1', 'CTS2'),
            ('CA2', 'CA3'), ('CA2', 'CTS1'), ('CA2', 'CTS2'),
            ('CA3', 'CTS1'), ('CA3', 'CTS2'),
            ('CTS1', 'CTS2')]
network.add_edges_from(list_edge)

position = {}
position['CTS1'] = [-1, 2]
position['CTS2'] = [1, 2]
position['CA1'] = [-2, -2]
position['CA2'] = [0, -2]
position['CA3'] = [2, -2]

plt.figure()
nx.draw(network, position, with_labels=True, node_size= 1000)
plt.show()

def neighbours(id_machine_1):
        list_neighbors = []
        for id_machine_2 in range(MACHINES_NUMBER):
            if CONGESTION_MATRIX[id_machine_1][id_machine_2] > 0:
                list_neighbors.append(id_machine_2)
        return list_neighbors

def random_choices(choices, weights):
    weights = [w * w for w in weights]
    alea = random.random() * sum(weights)
    step = 0
    for i in range(len(choices)):
        step += weights[i]
        if alea <= step:
            return choices[i]


## ROUTING
def static_routing(id_source, id_destination):
    route = []
    route.append(id_source)
    while route[-1] != id_destination:
        if id_destination == 1:
            route.append(id_destination)
        elif route[-1] == 0 or route[-1] == 2:
            route.append(((route[-1] + 1) // CA_NUMBER) + CA_NUMBER)
        else:
            route.append(id_destination)
    return route

def load_balancing_routing(id_source, id_destination):
    route = []
    visited_ids = []
    route.append(id_source)
    visited_ids.append(id_source)

    while route[-1] != id_destination:
        neighbors =neighbours(route[-1])
        neighbors = list(filter(lambda x: x not in visited_ids, neighbors))
        
        if len(route) > 2 and id_destination in neighbors:
            route.append(id_destination)
            return route
        
        weights = [CONGESTION_MATRIX[route[-1]][i] for i in neighbors]
        next_hop = random_choices(neighbors, weights)
        route.append(next_hop)
        visited_ids.append(next_hop)
    return route

def adaptive_routing(id_source,id_destination):
    route = []
    visited_ids = []
    route.append(id_source)
    visited_ids.append(id_source)

    while route[-1] != id_destination:
        neighbors = neighbours(route[-1])
        neighbors = list(filter(lambda x: x not in visited_ids, neighbors))
        
        if len(route) > 2 and id_destination in neighbors:
            route.append(id_destination)
            return route
        
        weights = [capacity[route[-1]][i] for i in neighbors]
        next_hop = random_choices(neighbors, weights)
        route.append(next_hop)
        visited_ids.append(next_hop)
    return route

## CALLS
def calls(env, id_source, id_destination, duration, algorithm):
    global failed_calls, total_call
    total_call += 1
    
    route = algorithm(id_source, id_destination)
    if all(capacity[u][v] > 0 for u, v in zip(route[:-1], route[1:])):
        for u, v in zip(route[:-1], route[1:]):
            capacity[u][v] -=1
            
        yield env.timeout(duration)
        
        for u, v in zip(route[:-1], route[1:]):
            capacity[u][v] +=1
    else:
        failed_calls += 1

def simulation(env, compt, algorithm):
    while True:
        yield env.timeout(2/compt)
        id_source = randint(0,2)
        id_destination = randint(0,2)
        while id_destination == id_source:
            id_destination = randint(0,2)
        
        env.process(calls(env, id_source, id_destination, randint(1, 5), algorithm))


## simulation
simu = range(1,2500,50)
result_static = []
result_lb = []
result_adapt = []
total_calls = []
for i in simu:
    env = simpy.Environment()
    total_call = 0
    failed_calls = 0
    env.process(simulation(env,i, static_routing))
    env.run(until=3600)
    result_static.append(failed_calls/total_call)
    capacity = [[0, 10, 0, 100, 100],
            [10, 0, 10, 100, 100],
            [0, 10, 0, 100, 100],
            [100, 100, 100, 0, 1000],
            [100, 100, 100, 1000, 0]]
    failed_calls = 0
    env.process(simulation(env,i, load_balancing_routing))
    env.run(until=7200)
    result_lb.append(failed_calls/total_call)
    capacity = [[0, 10, 0, 100, 100],
            [10, 0, 10, 100, 100],
            [0, 10, 0, 100, 100],
            [100, 100, 100, 0, 1000],
            [100, 100, 100, 1000, 0]]
    failed_calls = 0
    env.process(simulation(env,i, adaptive_routing))
    env.run(until=10800)
    result_adapt.append(failed_calls/total_call)
    capacity = [[0, 10, 0, 100, 100],
            [10, 0, 10, 100, 100],
            [0, 10, 0, 100, 100],
            [100, 100, 100, 0, 1000],
            [100, 100, 100, 1000, 0]]
    
nb_calls_per_second = [1/(2/i) for i in simu]
plt.plot(nb_calls_per_second,result_static, label='Static routing')
plt.plot(nb_calls_per_second,result_lb, label='Load balancing routing')
plt.plot(nb_calls_per_second,result_adapt, label='Adaptive routing')
plt.grid(True)
plt.xlabel('Number of calls by seconds')
plt.ylabel('failed calls / total calls')
plt.legend()
# Affichage
plt.show()