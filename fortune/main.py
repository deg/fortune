import random
import sys

FORTUNES = [
    "You will have a great day!",
    "A surprise awaits you around the corner.",
    "Hard work pays off in the long run.",
    "Be careful what you wish for; you might just get it.",
    "The early bird catches the worm, but the second mouse gets the cheese.",
    "Your creativity will lead to great things.",
    "A journey of a thousand miles begins with a single step.",
    "Everything happens for a reason.",
    "Don't let yesterday take up too much of today.",
    "The best way to predict the future is to create it."
]

def main():
    if len(sys.argv) > 1 and sys.argv[1] in ["--help", "-h"]:
        print("Usage: fortune")
        print("Displays a random fortune.")
        return

    print(random.choice(FORTUNES))

if __name__ == "__main__":
    main()
