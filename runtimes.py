import numpy as np
from typer import run, Argument
import matplotlib.pyplot as plt


runtimes = {
    'Floyd-Warshall (1962)':    lambda n: n**3,
    'Fredman (1976)':           lambda n: n**3 * (np.log(np.log(n)) / np.log(n))**(1 / 3),
    'Takaoka (1992)':           lambda n: n**3 * np.sqrt(np.log(np.log(n)) / np.log(n)),
    'Dobosiewicz (1990)':       lambda n: n**3 * 1 / np.sqrt(np.log(n)),
    'Han (2004)':               lambda n: n**3 * (np.log(np.log(n)) / np.log(n))**(5/7),
    'Takaoka (2005)':           lambda n: n**3 * (np.log(np.log(n)) / np.log(n)),
    'Zwick (2004)':             lambda n: n**3 * np.sqrt(np.log(np.log(n))) / np.log(n),
    'Chan (2007)':              lambda n: n**3 / np.log(n)
}


def main(
    plot: bool = Argument(True, help='If True, plot the figures during runtime.')
):
    ns = np.array(range(10, 100))
    labels = []
    
    plt.figure(1)
    for label, expr in runtimes.items():
        plt.plot(ns, expr(ns))
        labels.append(label)
    plt.legend(labels)
    plt.title('Runtimes in comparison')
    plt.xlabel('Number of graph nodes n')
    plt.ylabel('Runtime')
    plt.savefig('imgs/runtime_comparison.pdf')
    
    plt.figure(2)
    ns = np.array(range(10, 100))
    plt.plot(ns, (runtimes['Floyd-Warshall (1962)'](ns) - runtimes['Chan (2007)'](ns)) / runtimes['Floyd-Warshall (1962)'](ns))
    plt.title('Proportional runtime Chan - Warshall')
    plt.xlabel('Number of graph nodes n')
    plt.ylabel('Proportional savings in runtime')
    plt.savefig('imgs/proportional_chan_warshall.pdf')
    
    if plot:
        plt.show(block=True)


if __name__ == '__main__':
    run(main)
