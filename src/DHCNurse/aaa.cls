Class DHCNurse.aaa Extends %RegisteredObject
{

/// Description
ClassMethod aaa(a) As %Status
{
    i a=1

    {
    s bb=$H
    s cc=$p(bb,",",1)
    s dd=$p(bb,",",2)
    s ee=$zd(cc,3)
    s ff=$zt(ee,3)
    b ;1112223333
    s ^hyf(a)="test"
    w "hello a"
    b ;222
    }
    else 
    {
    w "not a"
    }
}

}
