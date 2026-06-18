
(*
  lists.polyml.org - 4th march 2005 discussion on foreign function calls 
  
  https://lists.polyml.org/hyperkitty/list/polyml@lists.polyml.org/thread/X3FTWZCWUW7RSF3OP3IKR7DYGIOCUNQW/
  link to 1994 c interface 
  https://www.polyml.org/documentation/Tutorials/CInterface.html

make the simplest shared library we can think of with one c routine called difference
compile it so we have a file called sample.so
>file sample.so
==> sample.so: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, not stripped


//sample.c code below 
  
int difference (int x, int y) {
    return x > y ? x - y : y - x;
}

// end of sample.c
// compilation instructions for sample.c to produce sample.so

gcc -c sample.c -o sample.o
ld -o sample.so sample.o -fPIC -shared  

// end compilation instructions 

luckily polyml documents its Foreign interface structure which is more than most , but there is
no example of how to use it , its just a blank reference staring back at you !

https://www.polyml.org/documentation/Reference/Foreign.xml

structure F = Foreign;
val lib = F.loadLibrary "./sample.so"
val sym_diff = F.getSymbol lib "difference"
val diff = F.buildCall2 (sym_diff, (F.cInt64,F.cInt64) ,F.cInt64);
val _ = print (Int.toString (diff(543,123)) ^ " characters\n");


we guessed buildCall2 is the routine we need , also we have no idea what buildCall2withApi means 

val buildCall2:
        symbol * ('a conversion * 'b conversion) * 'c conversion ->
          'a * 'b -> 'c

this means if we pass buildCall2 a tuple of 3 elements  (symbol,args-tuple,return-value]
1 = the symbol
2 = the inputs args-tuple - here a 2 element tuple since c code difference takes 2 arguments !
3 = the return value

for item 1 the symbol is what is found when we look in the shared library "sample.so"
under the symbol "difference"

the -fPIC means position independent code which is somewhat nice property to have 

looking further down the Foreign.xml document we find buildCall14 which i guess takes 14
parameters in a single c call , wow.

we may also have to wrap any C++ code in a dumb C wrapper to ensure it agrees with polyml C interface
so we will be looking at decoding C++ library , generating C wrapper , generating polyml interface code.

also this does not touch on the sticky issue of once all this is in place , who gets to hold the
candle of the raw memory and when/how is it allocated , when/how is it deallocated 

*)

(* polyml code  *)
structure F = Foreign;
val lib = F.loadLibrary "./sample.so"
val sym_diff = F.getSymbol lib "difference"
val diff = F.buildCall2 (sym_diff, (F.cInt64,F.cInt64) ,F.cInt64);
val _ = print (Int.toString (diff(543,123)) ^ " characters\n");

(*
we can adjust the parameters F.cInt64 may only be F.cInt32 size differences or signed to unsigned

most important part is how C type - translates to - Polyml type

did we cover callbacks ?

mostly C code like macros are black art , and simply do not exist at runtime , there is
no way around this ,
also C macros are not simple to evaluate , does clang help us here ? does it have a list of
macros it knows about sitting on the shelf to convert for me

once we cover this hurdle we also then have a library that we still have to learn how to use !

like if i give you a cairo library for polyml , with no documentation , its of little help ,
similarly for sdl , raylib etc..

also database postgres or mysql would be nice to haves  

do i have a seperate process that acts as a client server - and simply fulfills my wishes ,
if it is a seperate process that means it can have its own dumb garbage collector ,
we simply send messages on a protocol ,
we get separation of concerns with reliable code ,


*)




