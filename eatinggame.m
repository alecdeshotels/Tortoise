actual = load('actual.txt')
desired = load('desired.txt')
difference = abs(actual - desired)
difference = difference ./ desired
difference(difference>=1)=1
maxScore = 100 / length(desired)
maxScore = maxScore-(maxScore .* difference)
total = sum(maxScore)
