# 矩阵运算 {#chap:matrix-operations}

> Eigenvectors from Eigenvalues [@Denton_2019_Eigen]

> 参考 [matlib](https://github.com/friendly/matlib) 和 Matrix 包，[SparseM](https://CRAN.R-project.org/package=SparseM) 更加强调稀疏矩阵的 Cholesky 分解和后退法，矩阵取子集和 Kronecker 积。矩阵计算一般介绍参考在线书籍 Stephen Boyd and Lieven Vandenberghe 最新著作 Introduction to Applied Linear Algebra – Vectors, Matrices, and Least Squares [@Boyd_2018_matrix] 及其 [Julia 语言实现](https://web.stanford.edu/~boyd/vmls/vmls-julia-companion.pdf)，矩阵分解部分参考 [Introduction to Linear Algebra, 5th Edition](http://math.mit.edu/~gs/linearalgebra/linearalgebra5_Matrix.pdf)
[fastmatrix](https://github.com/faosorios/fastmatrix) 各种矩阵操作


<!-- 解释基本的矩阵概念，比如秩、迹、行列式、直积等 -->

分块矩阵操作，各类分解算法，及其 R 实现


```r
library(Matrix)
```

以 attitude 数据集为例介绍各种矩阵操作


```r
head(attitude)
```

```
##   rating complaints privileges learning raises critical advance
## 1     43         51         30       39     61       92      45
## 2     63         64         51       54     63       73      47
## 3     71         70         68       69     76       86      48
## 4     61         63         45       47     54       84      35
## 5     81         78         56       66     71       83      47
## 6     43         55         49       44     54       49      34
```

rating 总体评价
complaints 处理员工投诉
privileges 不允许特权
learning 学习机会
raises	根据表现晋升
critical 批评
advancel 进步


```r
fit <- lm(rating ~. , data = attitude)
summary(fit) # 模型是显著的，很多变量的系数不显著
```

```
## 
## Call:
## lm(formula = rating ~ ., data = attitude)
## 
## Residuals:
##      Min       1Q   Median       3Q      Max 
## -10.9418  -4.3555   0.3158   5.5425  11.5990 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)    
## (Intercept) 10.78708   11.58926   0.931 0.361634    
## complaints   0.61319    0.16098   3.809 0.000903 ***
## privileges  -0.07305    0.13572  -0.538 0.595594    
## learning     0.32033    0.16852   1.901 0.069925 .  
## raises       0.08173    0.22148   0.369 0.715480    
## critical     0.03838    0.14700   0.261 0.796334    
## advance     -0.21706    0.17821  -1.218 0.235577    
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 7.068 on 23 degrees of freedom
## Multiple R-squared:  0.7326,	Adjusted R-squared:  0.6628 
## F-statistic:  10.5 on 6 and 23 DF,  p-value: 1.24e-05
```

```r
anova(fit)
```

```
## Analysis of Variance Table
## 
## Response: rating
##            Df  Sum Sq Mean Sq F value    Pr(>F)    
## complaints  1 2927.58 2927.58 58.6026 9.056e-08 ***
## privileges  1    7.52    7.52  0.1505    0.7016    
## learning    1  137.25  137.25  2.7473    0.1110    
## raises      1    0.94    0.94  0.0189    0.8920    
## critical    1    0.56    0.56  0.0113    0.9163    
## advance     1   74.11   74.11  1.4835    0.2356    
## Residuals  23 1149.00   49.96                      
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

<!-- 矩阵变换对应的几何意义，和实际数据对应的意义 -->


```r
attitude_mat <- as.matrix.data.frame(attitude)
# 生成演示用的矩阵
demo_mat <- t(attitude_mat[, -1]) %*% attitude_mat[, -1]
```


## 矩阵乘法 {#subsec:matrix-multiplication}


```r
A <- matrix(c(1, 2, 2, 3), nrow = 2)
A
```

```
##      [,1] [,2]
## [1,]    1    2
## [2,]    2    3
```

```r
B <- matrix(c(1, 2, 3, 4, 5, 6), nrow =2)
B
```

```
##      [,1] [,2] [,3]
## [1,]    1    3    5
## [2,]    2    4    6
```

通常的矩阵乘法也叫矩阵内积


```r
A %*% B
```

```
##      [,1] [,2] [,3]
## [1,]    5   11   17
## [2,]    8   18   28
```


```r
A ** 2
```

```
##      [,1] [,2]
## [1,]    1    4
## [2,]    4    9
```

```r
A ^ 2
```

```
##      [,1] [,2]
## [1,]    1    4
## [2,]    4    9
```


```r
A ** A
```

```
##      [,1] [,2]
## [1,]    1    4
## [2,]    4   27
```

## Hadamard 积 {#subsec:hadamard-product}

Hadamard 积（法国数学家 Jacques Hadamard）也叫 Schur 积（德国数学家Issai Schur ）或 entrywise 积是两个维数相同的矩阵对应元素相乘，特别地，$A^2$ 表示将矩阵 $A$ 的每个元素平方

$$
(A\circ B)_{ij} = (A)_{ij}(B)_{ij}
$$

$$
\begin{bmatrix}
 a_{11} & a_{12}  & a_{13} \\ 
 a_{21} & a_{22}  & a_{23} \\ 
 a_{31} & a_{32}  & a_{33} 
\end{bmatrix}
\circ
\begin{bmatrix}
 b_{11} & b_{12}  & b_{13} \\ 
 b_{21} & b_{22}  & b_{23} \\ 
 b_{31} & b_{32}  & b_{33} 
\end{bmatrix}
= 
\begin{bmatrix}
 a_{11}b_{11} & a_{12}b_{12}  & a_{13}b_{13} \\ 
 a_{21}b_{21} & a_{22}b_{22}  & a_{23}b_{23} \\ 
 a_{31}b_{31} & a_{32}b_{32}  & a_{33}b_{33} 
\end{bmatrix}
$$


```r
A^2
```

```
##      [,1] [,2]
## [1,]    1    4
## [2,]    4    9
```

## 矩阵转置 {#subsec:matrix-transpose}


```r
t(B)
```

```
##      [,1] [,2]
## [1,]    1    2
## [2,]    3    4
## [3,]    5    6
```


## 矩阵外积 {#subsec:outer-product}


```r
A %o% B # outer(A, B, FUN = "*")
```

```
## , , 1, 1
## 
##      [,1] [,2]
## [1,]    1    2
## [2,]    2    3
## 
## , , 2, 1
## 
##      [,1] [,2]
## [1,]    2    4
## [2,]    4    6
## 
## , , 1, 2
## 
##      [,1] [,2]
## [1,]    3    6
## [2,]    6    9
## 
## , , 2, 2
## 
##      [,1] [,2]
## [1,]    4    8
## [2,]    8   12
## 
## , , 1, 3
## 
##      [,1] [,2]
## [1,]    5   10
## [2,]   10   15
## 
## , , 2, 3
## 
##      [,1] [,2]
## [1,]    6   12
## [2,]   12   18
```

直积/克罗内克积


```r
A %x% B # kronecker(A, B, FUN = "*")
```

```
##      [,1] [,2] [,3] [,4] [,5] [,6]
## [1,]    1    3    5    2    6   10
## [2,]    2    4    6    4    8   12
## [3,]    2    6   10    3    9   15
## [4,]    4    8   12    6   12   18
```

## 矩阵乘方 {#subsec:matrix-exp}

矩阵 A 首先是一个方阵，对称性和正定性未知，n 个 矩阵 A 相乘

统计之都论坛讨论如何求矩阵的乘方 <https://d.cosx.org/d/5619-svd>

```r
"%^%" <- function(mat, pow) {
  if (!is.matrix(mat)) mat <- as.matrix(mat)
  stopifnot(!diff(dim(mat)))
  if (pow < 0) {
    pow <- -pow
    mat <- solve(mat)
  }
  pow <- round(pow)
  switch(pow + 1, return(diag(1, nrow(mat))), return(mat))
  get.exponents <- function(pow)
    if (pow == 0) NULL else c(k <- 2^floor(log2(pow)), get.exponents(pow - k))
  ans <- diag(nrow(mat))
  dlog2exp <- rev(-diff(c(log2(get.exponents(pow)), 0)))
  for (j in 1:length(dlog2exp)) {
    if (dlog2exp[j]) for (i in 1:dlog2exp[j]) mat <- mat %*% mat
    ans <- ans %*% mat
  }
  ans
}
```

奇异值分解


```r
s <- svd(A)
all.equal(s$u%*%diag(s$d)%*%t(s$v),A)
```

```
## [1] TRUE
```

特征值及分解 $A = V \Lambda V^{-1}$ 求解矩阵 A 的 n 次方


```r
eigen(A)
```

```
## eigen() decomposition
## $values
## [1]  4.236068 -0.236068
## 
## $vectors
##           [,1]       [,2]
## [1,] 0.5257311 -0.8506508
## [2,] 0.8506508  0.5257311
```

```r
eigen(A)$vectors %*% diag(eigen(A)$values) %*% solve(eigen(A)$vectors)
```

```
##      [,1] [,2]
## [1,]    1    2
## [2,]    2    3
```

```r
eigen(A)$vectors %*% diag(eigen(A)$values)^3 %*% solve(eigen(A)$vectors)
```

```
##      [,1] [,2]
## [1,]   21   34
## [2,]   34   55
```

```r
A %*% A %*% A
```

```
##      [,1] [,2]
## [1,]   21   34
## [2,]   34   55
```

## 矩阵求幂 {#subsec:matrix-power}


```r
2^A
```

```
##      [,1] [,2]
## [1,]    2    4
## [2,]    4    8
```

```r
exp(A)
```

```
##          [,1]      [,2]
## [1,] 2.718282  7.389056
## [2,] 7.389056 20.085537
```

[expm](https://cran.r-project.org/web/packages/expm/index.html) 包含 更多关于矩阵开方、取对数等计算

## 矩阵交叉积 {#subsec:matrix-crossproduct}

交叉积 $A^{\top}A$


```r
crossprod(A, A)  #  t(x) %*% y
```

```
##      [,1] [,2]
## [1,]    5    8
## [2,]    8   13
```

```r
tcrossprod(A, A) #  x %*% t(y)
```

```
##      [,1] [,2]
## [1,]    5    8
## [2,]    8   13
```

## 矩阵行列式 {#subsec:matrix-determinant}


```r
det(A)
```

```
## [1] -1
```

expm 包计算矩阵 $e^{\mathbf{A}}$

## 矩阵条件数 {#subsec:matrix-cond-num}


```r
library(Matrix)
base::rcond(A)
```

```
## [1] 0.04
```

```r
kappa(A)
```

```
## [1] 21.85714
```

```r
Matrix::rcond(Matrix::Hilbert(6))
```

```
## [1] 3.439939e-08
```

```r
Matrix::rcond(A)
```

```
## [1] 0.04
```

## 矩阵求逆 {#subsec:matrix-inverse}


```r
solve(A)
```

```
##      [,1] [,2]
## [1,]   -3    2
## [2,]    2   -1
```

应用之线性方程组


```r
B <- Hilbert(6)
b <- rowSums(B)
# not inv
solve(B,b) 
```

```
## 6 x 1 Matrix of class "dgeMatrix"
##      [,1]
## [1,]    1
## [2,]    1
## [3,]    1
## [4,]    1
## [5,]    1
## [6,]    1
```

```r
# inv
solve(B) %*% b
```

```
## 6 x 1 Matrix of class "dgeMatrix"
##      [,1]
## [1,]    1
## [2,]    1
## [3,]    1
## [4,]    1
## [5,]    1
## [6,]    1
```


Moore-Penrose generalized inverse 广义逆，如果 A 可逆则，广义逆就是逆


```r
library(MASS) # ginv 来自 MASS 包
ginv(A)
```

```
##      [,1] [,2]
## [1,]   -3    2
## [2,]    2   -1
```

```r
A %*% ginv(A) %*% A
```

```
##      [,1] [,2]
## [1,]    1    2
## [2,]    2    3
```

```r
ginv(A) %*% A %*% ginv(A)
```

```
##      [,1] [,2]
## [1,]   -3    2
## [2,]    2   -1
```

```r
t(A %*% ginv(A))
```

```
##               [,1]         [,2]
## [1,]  1.000000e+00 8.881784e-16
## [2,] -8.881784e-16 1.000000e+00
```

```r
A %*% ginv(A)
```

```
##              [,1]          [,2]
## [1,] 1.000000e+00 -8.881784e-16
## [2,] 8.881784e-16  1.000000e+00
```

```r
t(ginv(A) %*% A)
```

```
##              [,1]          [,2]
## [1,] 1.000000e+00 -8.881784e-16
## [2,] 8.881784e-16  1.000000e+00
```

```r
ginv(A) %*% A
```

```
##               [,1]         [,2]
## [1,]  1.000000e+00 8.881784e-16
## [2,] -8.881784e-16 1.000000e+00
```

## 矩阵伴随 {#subsec:matrix-adjoint}

伴随矩阵 $A*A^{\star} = A^{\star} *A = |A|*I, A^{\star} = |A|*A^{-1}$

- $|A^{\star}| = |A|^{n-1}, A \in \mathbb{R}^{n\times n},n \geq 2$
- $(A^{\star})^{\star} = |A|^{n-2}A, A \in \mathbb{R}^{n\times n},n \geq 2$
- $(A^{\star})^{\star}$ A 的 n 次伴随是？



```r
det(A)*solve(A)
```

```
##      [,1] [,2]
## [1,]    3   -2
## [2,]   -2    1
```




## 矩阵范数 {#subsec:matrix-norm}

向量和矩阵的范数，包括1，2，无穷范数，其他操作看 Matrix 包，尤其关于稀疏矩阵计算部分

$1$-范数
:  列和绝对值最大的

$\infty$ - 范数
:  行和绝对值最大的

Frobenius - 范数
:  Euclidean 范数

$M$ - 范数
:  矩阵里模最大的元素，矩阵里面的元素可能含有复数，所以取模最大

$2$ - 范数
:  又称谱范数，矩阵最大的奇异值，如果是方阵，就是最大的特征值


```r
norm(A, type = "1") # max(abs(colSums(A)))
```

```
## [1] 5
```

```r
norm(A, type = "I") # max(abs(rowSums(A)))
```

```
## [1] 5
```

```r
norm(A, type = "F")
```

```
## [1] 4.242641
```

```r
norm(A, type = "M") #
```

```
## [1] 3
```

```r
norm(A, type = "2") # max(svd(A)$d)
```

```
## [1] 4.236068
```

::: rmdinfo
显然，$1-,\infty-,M-$ 的范数计算比 $F-$ 范数快，函数 `norm` 默认情况下求 $1-$ 范数
:::

## 矩阵求秩 {#subsec:matrix-rank}


```r
qr(A)$rank # or qr.default(A)$rank
```

```
## [1] 2
```

## 矩阵求迹 {#subsec:matrix-trace}

若

$$
A = \begin{bmatrix}
 a_{11} & a_{12}  & a_{13} \\ 
 a_{21} & a_{22}  & a_{23} \\ 
 a_{31} & a_{32}  & a_{33} 
\end{bmatrix}
$$

则矩阵 $A$ 的迹 $\operatorname{tr}(A) = \sum_{i=1}^{n}a_{ii}$


```r
sum(diag(A))
```

```
## [1] 4
```


特殊矩阵的构造

## 单位矩阵 {#subsec:identity-matrix}

矩阵对角线上全是1，其余位置都是0

$$
A = \begin{bmatrix}
 1 & 0  & 0 \\ 
 0 & 1  & 0 \\ 
 0 & 0  & 1 
\end{bmatrix}
$$


```r
diag(rep(3))
```

```
##      [,1] [,2] [,3]
## [1,]    1    0    0
## [2,]    0    1    0
## [3,]    0    0    1
```

而全1矩阵是所有元素都是1的矩阵，可以借助外积运算构造，如3阶全1矩阵


```r
rep(1,3) %o% rep(1,3) 
```

```
##      [,1] [,2] [,3]
## [1,]    1    1    1
## [2,]    1    1    1
## [3,]    1    1    1
```


## 对角矩阵 {#subsec:matrix-diagonals}


```r
diag(A)       # diagonal of a matrix
```

```
## [1] 1 3
```

```r
diag(diag(A)) # construct a diagonal matrix
```

```
##      [,1] [,2]
## [1,]    1    0
## [2,]    0    3
```

## 上/下三角矩阵 {#subsec:upper-matrix}

矩阵下三角

row 和 col


```r
row(A)
```

```
##      [,1] [,2]
## [1,]    1    1
## [2,]    2    2
```

```r
col(A)
```

```
##      [,1] [,2]
## [1,]    1    2
## [2,]    1    2
```

```r
A[row(A)]
```

```
## [1] 1 3
```


```r
upper.tri(A) # 矩阵上三角
```

```
##       [,1]  [,2]
## [1,] FALSE  TRUE
## [2,] FALSE FALSE
```

```r
A[upper.tri(A)]
```

```
## [1] 2
```

```r
A[lower.tri(A)] <- 0 # 获得上三角矩阵
A
```

```
##      [,1] [,2]
## [1,]    1    2
## [2,]    0    3
```

- 下三角矩阵


```r
A <- matrix(c(1, 2, 2, 3), nrow = 2)
A
```

```
##      [,1] [,2]
## [1,]    1    2
## [2,]    2    3
```

```r
lower.tri(A)
```

```
##       [,1]  [,2]
## [1,] FALSE FALSE
## [2,]  TRUE FALSE
```

```r
A[lower.tri(A)]
```

```
## [1] 2
```

```r
A[upper.tri(A)] <- 0 # 获得下三角矩阵
A
```

```
##      [,1] [,2]
## [1,]    1    0
## [2,]    2    3
```

```r
A <- matrix(c(1, 2, 2, 3), nrow = 2)
A[row(A) < col(A)] <- 0
A
```

```
##      [,1] [,2]
## [1,]    1    0
## [2,]    2    3
```

## 稀疏矩阵 {#subsec:sparse-matrix}


```r
dn <- list(LETTERS[1:3], letters[1:5])
## pointer vectors can be used, and the (i,x) slots are sorted if necessary:
## 使用指针构造
m <- sparseMatrix(i = c(3,1, 3:2, 2:1), p= c(0:2, 4,4,6), x = 1:6, dimnames = dn)
m
```

```
## 3 x 5 sparse Matrix of class "dgCMatrix"
##   a b c d e
## A . 2 . . 6
## B . . 4 . 5
## C 1 . 3 . .
```

```r
## 典型构造方式
i <- c(1,3:8); j <- c(2,9,6:10); x <- 7 * (1:7)
(AA <- sparseMatrix(i, j, x = x))                    ##  8 x 10 "dgCMatrix"
```

```
## 8 x 10 sparse Matrix of class "dgCMatrix"
##                              
## [1,] . 7 . . .  .  .  .  .  .
## [2,] . . . . .  .  .  .  .  .
## [3,] . . . . .  .  .  . 14  .
## [4,] . . . . . 21  .  .  .  .
## [5,] . . . . .  . 28  .  .  .
## [6,] . . . . .  .  . 35  .  .
## [7,] . . . . .  .  .  . 42  .
## [8,] . . . . .  .  .  .  . 49
```

## 三对角矩阵 {#subsec:triangular-matrix}




<!-- 各类矩阵分解技术，及其算法实现、适用范围，最常见的 LU 分解、SVD 和 QR 分解，参考 R 内置的帮助文档及其实现 -->




## LU 分解 {#subsec:lu-decomposition}

## Schur 分解 {#subsec:schur-decomposition}

## Cholesky 分解 {#subsec:choleski-decomposition}

实对称正定矩阵的 Choleski 分解


```r
chol(A + diag(rep(1,2)))
```

```
##          [,1] [,2]
## [1,] 1.414214    0
## [2,] 0.000000    2
```

```r
# Inverse from Choleski (or QR) Decomposition
Matrix::chol2inv(A + diag(rep(1,2)))
```

```
##      [,1]   [,2]
## [1,] 0.25 0.0000
## [2,] 0.00 0.0625
```

`Matrix::Cholesky` 实现稀疏 Cholesky 分解




## 特征值分解 {#subsec:eigenvalues-decomposition}

特征值分解（Eigenvalues Decomposition）也叫谱分解（Spectral Decomposition）


```r
eigen(A)
```

```
## eigen() decomposition
## $values
## [1] 3 1
## 
## $vectors
##      [,1]       [,2]
## [1,]    0  0.7071068
## [2,]    1 -0.7071068
```


## SVD 分解 {#subsec:Singular-Value-Decomposition}

[Fast truncated singular value decompositions](https://github.com/bwlewis/irlba) 
奇异值分解是特征值分解的推广


```r
svd(A)
```

```
## $d
## [1] 3.6502815 0.8218544
## 
## $u
##            [,1]       [,2]
## [1,] -0.1601822 -0.9870875
## [2,] -0.9870875  0.1601822
## 
## $v
##            [,1]       [,2]
## [1,] -0.5847103 -0.8112422
## [2,] -0.8112422  0.5847103
```

```r
svd(A)$d
```

```
## [1] 3.6502815 0.8218544
```

邱怡轩将奇异值分解用于图像压缩 <https://cosx.org/2014/02/svd-and-image-compression> 并制作了 [Shiny App](https://yihui.shinyapps.io/imgsvd/) 交互式演示

## QR 分解 {#subsec:QR-Decomposition}


```r
qr.default(A)
```

```
## $qr
##            [,1]      [,2]
## [1,] -2.2360680 -2.683282
## [2,]  0.8944272  1.341641
## 
## $rank
## [1] 2
## 
## $qraux
## [1] 1.447214 1.341641
## 
## $pivot
## [1] 1 2
## 
## attr(,"class")
## [1] "qr"
```

```r
qr.X(qr.default(A))
```

```
##      [,1] [,2]
## [1,]    1    0
## [2,]    2    3
```

```r
qr.Q(qr.default(A))
```

```
##            [,1]       [,2]
## [1,] -0.4472136 -0.8944272
## [2,] -0.8944272  0.4472136
```

```r
qr.R(qr.default(A))
```

```
##           [,1]      [,2]
## [1,] -2.236068 -2.683282
## [2,]  0.000000  1.341641
```

```r
qr.Q(qr.default(A)) %*% qr.R(qr.default(A))
```

```
##      [,1]          [,2]
## [1,]    1 -2.220446e-16
## [2,]    2  3.000000e+00
```

用 [Householder 变换](https://www.wikiwand.com/en/Householder_transformation) 做 QR 分解 [@Bates_1988_Nonlinear] 及其 R 语言实现 <https://rpubs.com/aaronsc32/qr-decomposition-householder>

Householder 变换是平面反射的一般情况：
要计算 $N\times P$ 维矩阵 $X$ 的 QR 分解，我们采用 Householder 变换

$$
\mathbf{H}_{u} = \mathbf{I} -2\mathbf{u}\mathbf{u}^{\top}
$$

其中 $I$ 是 $N\times N$ 维的单位矩阵，$u$ 是 $N$ 维单位向量，即 $\| \mathbf{u}\| = \sqrt{\mathbf{u}\mathbf{u}^{\top}} = 1$。则 $H_u$ 是对称正交的，因为

$$
\mathbf{H}_{u}^{\top} = \mathbf{I}^{\top} - 2\mathbf{u}\mathbf{u}^{\top} = \mathbf{H}_{u}
$$

并且

$$
\mathbf{H}_{u}^{\top}\mathbf{H}_{u} =  \mathbf{I} -4\mathbf{u}\mathbf{u}^{\top} + 4\mathbf{u}\mathbf{u}^{\top}\mathbf{u}\mathbf{u}^{\top} = \mathbf{I}
$$

让 $\mathbf{H}_{u}$ 乘以向量 $\mathbf{y}$，即

$$
\mathbf{H}_{u}\mathbf{y} = \mathbf{y} - 2\mathbf{u}\mathbf{u}^{\top}\mathbf{y}
$$

它是 $y$ 关于垂直于过原点的 $u$ 的直线的反射，只要


\begin{equation}
\mathbf{u} = \frac{\mathbf{y} - \| \mathbf{y} \|\mathbf{e}_{1}}{\| \mathbf{y} - \| \mathbf{y} \|\mathbf{e}_{1}\|} (\#eq:householder-negative)
\end{equation}


或者


\begin{equation}
\mathbf{u} = \frac{\mathbf{y} + \| \mathbf{y} \|\mathbf{e}_{1}}{\| \mathbf{y} + \| \mathbf{y} \|\mathbf{e}_{1}\|} (\#eq:householder-positive)
\end{equation}


其中 $\mathbf{e}_{1} = (1,0,\ldots,0)^{\top}$，Householder 变换使得向量 $y$ 成为 $x$ 轴，在新的坐标系统中，向量 $H_{u}y$ 的坐标为 $(\pm\|y\|, 0, \ldots, 0)^\top$

举个例子


借助 Householder 变换做 QR 分解的优势：

1. 更快、数值更稳定比直接构造 Q，特别当 N 大于 P 的时候
1. 相比于存储矩阵 Q 的 $N^2$ 个元素，Householder 变换只存储 P 个向量 $u_1,\ldots,u_P$
1. QR 分解的真实实现，比如在 LINPACK 中，定义 $u$ 的时候，公式 \@ref(eq:householder-negative) 或 \@ref(eq:householder-positive) 的选择基于$y$的第一个坐标的符号。如果坐标是负的，使用公式\@ref(eq:householder-negative)，如果是正的，使用公式 \@ref(eq:householder-positive)， 这个做法可以使得数值计算更加稳定。


Stan 实现的 QR 分解在贝叶斯线性回归模型中的应用[^qr-stan]

[^qr-stan]: https://mc-stan.org/users/documentation/case-studies/qr_regression.html
  
## Jordan 分解 {#subsec:jordan-Decomposition}


## Givens 旋转 {#subsec:Givens-Rotation}

- Givens 旋转 <https://www.wikiwand.com/en/Givens_rotation>


- 帽子矩阵在统计中的应用 回归与方差分析 [@David_1978_Hat]



## 特殊函数 {#sec:special-functions}

### 阶乘 {#factorial}

- 阶乘 $n! = 1\times 2\times 3\cdots n$ 
- 双阶乘 $(2n+1)!! = 1 \times 3\times 5 \times \cdots \times (2n+1), n = 0,1,2,\cdots$


```r
factorial(5) # 阶乘
```

```
## [1] 120
```

```r
seq(from = 1, to = 5, length.out = 3)
```

```
## [1] 1 3 5
```

```r
prod(seq(from = 1, to = 5, length.out = 3)) # 连乘 双阶乘
```

```
## [1] 15
```

```r
seq(5)
```

```
## [1] 1 2 3 4 5
```

```r
cumprod(seq(5)) # 累积
```

```
## [1]   1   2   6  24 120
```

```r
cumsum(seq(5)) # 累和
```

```
## [1]  1  3  6 10 15
```

此外还有 `cummax` 和 `cummin`

- 组合数 $C_{n}^{k} = \frac{n(n-1)…(n-k+1)}{k!}$

$C_{5}^{3} = \frac{5 \times 4 \times 3}{3 \times 2 \times 1}$


```r
choose(5,3)
```

```
## [1] 10
```

> 斯特林公式

### 伽马函数 {#gamma}

$\Gamma(x) = \int_{0}^{\infty} t^{x-1}\exp(-t)dt$
$\Gamma(n) = (n-1)!, n \in \mathbb{Z}^{+}$


```r
gamma(2)
```

```
## [1] 1
```

```r
gamma(10)
```

```
## [1] 362880
```

```r
gamma2 <- function(t,x){
  t^(x-1)*exp(-t)
}
integrate(gamma2, lower = 0, upper = + Inf, x = 10)
```

```
## 362880 with absolute error < 0.025
```

- psigamma(x, deriv) 表示 $\psi(x)$ 的 `deriv` 阶导数

$\mathrm{digamma}(x) \triangleq \psi(x) = \frac{d}{dx}{\ln \Gamma(x)} = \Gamma'(x) / \Gamma(x)$


```r
# 例1
x <- 2
eval(deriv(~ gamma(x), "x"))/gamma(x)
```

```
## [1] 1
## attr(,"gradient")
##              x
## [1,] 0.4227843
```

```r
# 与此等价
psigamma(2, 0)
```

```
## [1] 0.4227843
```

```r
digamma(x) # psi(x) 的一阶导数
```

```
## [1] 0.4227843
```

```r
trigamma(x) # psi(x) 的二阶导数
```

```
## [1] 0.6449341
```

```r
# 例2
eval(deriv(~ psigamma(x, 1), "x"))
```

```
## [1] 0.6449341
## attr(,"gradient")
##               x
## [1,] -0.4041138
```

```r
# 与此等价
psigamma(2, 2)
```

```
## [1] -0.4041138
```

```r
# 注意与下面这个例子比较
dx2x <- deriv(~ x^3, "x")
eval(dx2x)
```

```
## [1] 8
## attr(,"gradient")
##       x
## [1,] 12
```

### 贝塔函数 {#beta}

$B(a,b) = \Gamma(a)\Gamma(b)/\Gamma(a+b) = \int_{0}^{1} t^{a-1} (1-t)^{b-1} dt$


```r
beta(1, 1)
```

```
## [1] 1
```

```r
beta(2, 3)
```

```
## [1] 0.08333333
```

```r
beta2 <- function(t, a, b) {
  t^(a - 1) * (1 - t)^(b - 1)
}
integrate(beta2, lower = 0, upper = 1, a = 2, b = 3)
```

```
## 0.08333333 with absolute error < 9.3e-16
```

### 贝塞尔函数 {#bessel}

```r
besselI(x, nu, expon.scaled = FALSE) # 修正的第一类
besselK(x, nu, expon.scaled = FALSE) # 修正的第二类
besselJ(x, nu) # 第一类
besselY(x, nu) # 第二类
```

- $\nu$ 贝塞尔函数的阶，可以是分数
- expon.scaled 是否使用指数表示


```r
nus <- c(0:5, 10, 20)
x <- seq(0, 4, length.out = 501)
plot(x, x,
  ylim = c(0, 6), ylab = "", type = "n",
  main = "Bessel Functions  I_nu(x)"
)
for (nu in nus) lines(x, besselI(x, nu = nu), col = nu + 2)
legend(0, 6, legend = paste("nu=", nus), col = nus + 2, lwd = 1)
```

<img src="matrix-operations_files/figure-html/modified-bessel-1.png" width="672" style="display: block; margin: auto;" />

