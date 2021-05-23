# 符号计算 {#chap:symbolic-computation}



Python 的符号计算模块 [sympy](https://github.com/sympy/sympy) [@SymPy] 不仅支持简单的四则运算，还支持微分、积分、解方程等，详见官方文档 <https://sympy.org/> 


```python
from sympy import * 
# 设置显示样式
init_printing(use_unicode=False, wrap_line=False)
x = Symbol('x')
# 积分
integrate(x**2 + x + 1, x)
# 因式分解
```

```
##  3    2    
## x    x     
## -- + -- + x
## 3    2
```

```python
factor(5*x**4/2 + 3*x**3 - 108*x**2/5 - 27*x - 81/10)
```

```
##                                                                           2
## 22.5*(0.333333333333333*x - 1.0)*(0.333333333333333*x + 1.0)*(1.0*x + 0.6)
```



```r
library(Ryacas)
```


```r
x <- ysym("x")
integrate(f = x^2 + x + 1, var = "x")
```

```
## y: x^3/3+x^2/2+x
```


```r
yac_str(y_fn("5*x^4/2 + 3*x^3 - 108*x^2/5 - 27*x - 81/10", "Factor"))
```

```
## [1] "5/2*(x+3)*(x-3)*(x+3/5)^2"
```


```r
eq <- function(x) x^2 + x + 1
integrate(f = eq, lower = 0, upper = 1)
```

```
## 1.833333 with absolute error < 2e-14
```

