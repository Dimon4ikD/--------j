# Количество n-значных десятичных чисел,
# сумма цифр которых равна величине i
def s(n,i)

if n==1
if 0<=i && i<10
return 1
else
return 0
end
else
t=0
for j in 0..9
t+=s(n-1,i-j)
end
return t
end
end

# Количество счастливых билетов с 2n-значными номерами
def happy(n)
t=0
for i in 0..9*n
t+=s(n,i)**2
end
return t
end

puts happy(6)