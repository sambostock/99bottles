class Bottles;def song;verses 99,0end;def verses s,e;s.downto(e).map{|n|verse n}*"\n"end;def verse n;r=(n+99)%100;w=" of beer on the wall";z='no more';"#{n==0?'No more':n} bottle#{n!=1??s:''}#{w}, #{n==0?z:n} bottle#{n!=1??s:''} of beer.\n#{n>0?"Take #{n==1?:it:'one'} down and pass it around":'Go to the store and buy some more'}, #{r==0?z:r} bottle#{r!=1??s:''}#{w}.\n"end;end
