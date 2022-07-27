

### Emacs macos
```

```

### Notes
#### Windows
- C-x 2 ：上下分割出两个 Window。
- C-x 3：左右分割出两个 Window。
- C-x 0：关闭光标所在处的 Window。
- C-x 1：只保留光标所在处的 Window，关闭其它 Window。其它 Window 的 Buffer 依然没有关闭，可以通过 "*Buffer List*" 查看。
- C-x o：将光标切换到下一个 Window。 

### rust
#### lang-server
```

```
#### Debug
```
$ brew install cmake llvm
$ git clone https://github.com/lldb-tools/lldb-mi
$ mkdir -p lldb-mi/build
$ cd lldb-mi/build
$ cmake ..
$ cmake --build .
$ ln -s $PWD/src/lldb-mi /usr/local/bin/lldb-mi
```

```
sudo DevToolsSecurity --enable
```
### typescript
#### lang-server
```

```
