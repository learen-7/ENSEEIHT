import matplotlib.pyplot as plt
from scipy import stats
import numpy as np

rssi = np.array([-34, -38, -33, -35, -39, -41, -39, -41, -44, -39, -36, -43, -43, -63, -53])
distance = np.array([0.5, 1, 1.5, 2, 2.5, 3, 3.5 , 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5])

regression = stats.linregress(distance, rssi)

regresison_plot = regression[0] * distance + regression[1]

print("Pente : "+ str(regression[0]) + "\nOrigine : "+str(regression[1]))

plt.plot(distance, rssi, 'o', label="Raw data")
plt.plot(distance,regresison_plot, 'r', label="Linear regression")
plt.legend()
plt.ylabel("RSSI")
plt.xlabel("Distance")
plt.title("Linear regresison of the RSSI by distance")

plt.show()