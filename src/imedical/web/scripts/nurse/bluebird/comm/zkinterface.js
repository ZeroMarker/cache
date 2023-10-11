
var hazkitem= new Hashtable();
var haqm = new Hashtable();  
var haqm = new Hashtable(); //签名hashitable
var haMult = new Hashtable(); //多选项hashitable
var hasavestr = new Hashtable();
var configstr=getconfig()
var ha = new Hashtable();
var demouser=""
var demogroudesc="护士长" //区别是否是护士长安全组
var EmrCodeDemo="DHCNURRecordhlhzjl" //维护护士长修改护士填的留名
//alert(configstr)
var userstr=""
var MultItems=""
var MultLength=15 //默认多选元素项目数
if (((configstr!="")&(configstr!=null))||(configstr=="@@"))
{
	if (configstr!="@@@") 
	{
	var splitstr=configstr.split('@')
	//alert(splitstr)
  var configstr2=splitstr[0]
  userstr=splitstr[1]
  var inputs1=configstr2.split('$')
  //alert(inputs1)
  hazkitem.clear();
  sethashvalue(hazkitem, inputs1);
  demouser=splitstr[2]
  MultItems=splitstr[3]
  if (MultItems!="")
  {
      var tms = MultItems.split('^')
      //alert(tms)
		  sethashvalue(haMult, tms);
  
  }
  
  } 
}
else
{
	alert("取质控配置信息出错了!请联系信息科")
}
//获取质控配置信息
//input:科室id ^模板code ^用户id ^用户code ^ 用户安全组 ^ 医院代码
//creater:cyf 20131109
function getconfig()
{	
	var configstr=""
	if ("undefined"!=typeof Getloccodezkitems) //判定csp有没有定义
	{		
     configstr = cspRunServerMethod(Getloccodezkitems, session['LOGON.CTLOCID'],EmrCode,session['LOGON.USERID'],session['LOGON.USERCODE'],session['LOGON.HOSPID']);
     
  }
  else
  {
     configstr=tkMakeServerCall("Nur.DHCNUREMRQC","Getloccodezkitems",session['LOGON.CTLOCID'],EmrCode,session['LOGON.USERID'],session['LOGON.USERCODE'],session['LOGON.HOSPID']);
     //alert(configstr)
  }
  return configstr
}

function getuserha()
{	
	//alert(userstr)
	
	if (userstr!="")
	{	
		var valstr=""
	  var strs3=userstr.split('^')
 	  for (i=0;i<strs3.length;i++)
    {
       var itm=strs3[i]
       if (itm=="") continue
       var but=Ext.getCmp(itm);  
       if (but.value!="")
       {
         if (valstr=="")
         {
     	     valstr=itm+"|"+but.value
         }
         else
         {
     	    valstr=valstr+"^"+itm+"|"+but.value
         }
       }
    }
    //alert(valstr)
    if (valstr!="")
    {   
   	  var tms = valstr.split('^')
		  sethashvalue(haqm, tms);	
	  }
	  
	}
}
//质控初始化
function setzkinit()
{
  //1 质控维护项
	for (var i=0 ; i<hazkitem.keys().length;i++)//for...in statement get all of Array's index
	{
		 var key = hazkitem.keys()[i]; 	
		 if (key=="") continue
	   var itm = Ext.getCmp(key); 	   
	   var zkstr=hazkitem.items(key)
		 var zkstr1=zkstr.split('^')			
		 itm.on('change',lisentAdd,this);
		 var mulkey=key+"_1"
		 var mulkeyobj = Ext.getCmp(mulkey); 
		 if (mulkeyobj) //是多选元素
		 {
		     AddMultQM(key,zkstr1); //如果关联签名处为空自动签名	 
		 }
		 
			//User^Item^Y允许为空^Y允许修改^Y本人修改^T开始时间^
			var fcval=itm.value
			if ((zkstr1[3]=="N")&(session['LOGON.GROUPDESC'].indexOf(demogroudesc)==-1)&(fcval!="")) itm.disable(); //不允许修改项 有值时不允许修改
			if (zkstr1[3]=="Y") //允许修改
		  {
					if (zkstr1[0]=="User")
					{
						if (ha.contains(zkstr1[1]))
						{
						    var userval=getval(ha.items(zkstr1[1])) //签名值
						    //alert(userval.indexOf(session['LOGON.USERID']))
					      if ((zkstr1[4]=="Y")&(userval.indexOf(session['LOGON.USERID'])==-1)&(userval!="")&(session['LOGON.GROUPDESC'].indexOf(demogroudesc)==-1)) //允许本人修改 签名值不是登录人
					      {
					  	    //itm.disable(); 
					      }
					      else
					      {
					  
				        }
				    }
				     //如果不为空则取消红色
	             	var itm2 = document.getElementById(key).value;
		                       	// alert(itm2)
		                    if (itm2!="undefined")
		                    {
		                       	 if (itm2!="")
		                       	 {
		                       	   var Itemsqm=Ext.fly(key);	
		                       	   Itemsqm.setStyle({background: '#FFFFFF'}) ; 
		                         } 
		                         if (itm2=="")
		                         {
		                         	 var Itemsqm=Ext.fly(key);	
		                       	   Itemsqm.setStyle({background: '#FF0000'}) ;
		                         }
		                    }
				  }
			} 
			
			 
  }	
  //多选元素变单选
  for (var i=0 ; i<haMult.keys().length;i++)//多选项初始化
	{
		 var key = haMult.keys()[i]; 	
	   var itm = Ext.getCmp(key); 
	   var multlength=haMult.items(key)
	   for (var j=1;j<=multlength;j++)
	   {
	        var itemmult=key+"_"+j     
	        AddMultEvent(itemmult,multlength);	    //增加多选触发事件 多选变单选      
	   }	   	   	   
	}
	//签名处变灰
  for (var i=0 ; i<haqm.keys().length;i++)//for...in statement get all of Array's index
	{
		 var key = haqm.keys()[i]; 	
	   var itm = Ext.getCmp(key); 
	   //alert(itm)
	   //var userval=itm.value//签名值
	   //if ((userval.indexOf(session['LOGON.USERID'])==-1)&(userval!="")) //允许本人修改 签名值不是登录人
		 //{		 	  
				itm.disable(); 
		 //}
	}
	//超级用户(护士长)签名处自动签名
	if (demouser!="") //超级用户维护不为空
	{
		 document.onkeydown=KeyDown; //回车签名
		 var demostr=demouser.split('^')
     //alert(demostr)
     for (i=0;i<demostr.length;i++)
     {
         var demoitm=demostr[i]
         var itm = Ext.getCmp(demoitm); 
         //if (session['LOGON.GROUPDESC'].indexOf(demogroudesc)==-1) //安全组非护士长的不允许修改
         //{
         	itm.disable()
      
         //}
         //else
         //{
         	 if ((document.getElementById(demoitm).value=="")&(session['LOGON.GROUPDESC'].indexOf(demogroudesc)>-1))
         	 {
         	  document.getElementById(demoitm).value=session['LOGON.USERNAME'] +"*"+session['LOGON.USERID'];
           }
         //}
     }
	}
	
}
function AddMultQMItem(item,multlength,zkstr,e) 
{

	        var itmsobj = Ext.getCmp(item);
	      	if ((itmsobj)&&(zkstr[0]=="User"))  //只有User类型才自动签名
	      	{     
               itmsobj.on("check",function(check)
	             {
	                  var checkval=itmsobj.getValue(); //当前值
	                  //var selectitem=itmsobj.getName();	
	                  var selectId=itmsobj.getItemId();	
	                  var selectitem=""	
	             
	                  if (checkval==true)
	                  {
	                  	 //alert(checkval)
	                     setuser(zkstr[1]) 
	                     //alert(44) 
	                  }  
	                  else  //取消选择取消签名
	                  {
	                     var itmsobjqm = Ext.getCmp(zkstr[1]);
	                     //itmsobjqm.setValue("")   
	                  }              	              
	             })          
	        }
}


//多选触发时签名
function AddMultQM(item,zkstr,e) 
{             
	      if (haMult.contains(item))
				{
					 MultLength=haMult.items(item)
				}
				for (iis=1;iis<=MultLength;iis++)
				{
				  var strisss=item+"_"+iis
				  AddMultQMItem(strisss,MultLength,zkstr);	                               	                        					       								     
			  }		
			
			  
			  			     
}
//添加多选事件响应  多选变单选
function AddMultEvent(item,multlength,e) 
{

	        var itmsobj = Ext.getCmp(item);
	      
	      	if (itmsobj)  
	      	{     
               itmsobj.on("check",function(check)
	             {
	                  var checkval=itmsobj.getValue(); //当前值
	                  //var selectitem=itmsobj.getName();	
	                   
	                  var selectId=itmsobj.getItemId();	
	                  var selectitem=""
	                  var selectitem_id="" //多选项第几项
	                  if (selectId.indexOf('_')>-1)
	                  {
	                    var sel=selectId.split('_')
	                    selectitem=sel[0];
	                    selectitem_id=sel[1];
	                  }
	                 var flagcheck=0
	                 for (var k=1;k<=multlength;k++)
	                 {                     
	                     var itemmultother=selectitem+"_"+k	 
	                     //alert(itemmultother)  
	                     var itmsobjother = Ext.getCmp(itemmultother);	
	                     if (itmsobjother)
	                     {
                    	                     if (itmsobjother.checked==true) flagcheck=1
                    	                      
                    	                     if ((itemmultother==selectId)||(checkval==false)) continue;	
                    	                                        
                    	                     if (itmsobjother)
                    	                     {
                    	                       itmsobjother.setValue(false)
                    	                     }   
                    	                        
                    	                     //多选项变更选择项时查询多选关联项
                    	                     	for (var i=0 ; i<hazkitem.keys().length;i++)//
                    	                      {
                    		                       var key = hazkitem.keys()[i]; 	
                    		                       if (key=="") continue
                    	                         var itm = Ext.getCmp(key); 	   
                    	                         var zkstr=hazkitem.items(key)
                    		                       var zkstr1=zkstr.split('^')
                    		                       if (zkstr1[0]!="Link")	continue //Link元素是关联质控项
                    		                       //alert(key)
                    		                        //找到关联项并且多选项的子项k没有在关联项中维护则清除该项颜色
                    		                       if ((zkstr1[1]==selectitem)&&(zkstr1[6].indexOf(k)==-1)) 
                    		                       {
                    		                       	 var Itemsqm=Ext.fly(key);	
                    		                       	 Itemsqm.setStyle({	   background: '#FFFFFF'   })   
                    		                       	 
                    		                       	                                                                    	
                    		                       }
                    		                       //多选元素，选中非关联项后清空多选元素关联项所关联其他元素的值
                    		                       //如多选项Item1有4项，其中第2，3项关联元素Item2,如果选中Item1_1或Item1_4则清空Item2的值及颜色
                    		                       if ((zkstr1[1]==selectitem)&&(selectitem_id!="")&&(zkstr1[6].indexOf(selectitem_id)==-1)) 
                    		                       {
                    		                       	//alert(selectId)
                    		                       	var itm2 = Ext.getCmp(key);
                    		                       	//alert(key)
                    		                       	itm2.setValue("")  
                    		                       	 var Itemsqm=Ext.fly(key);	
                    		                       	 Itemsqm.setStyle({	   background: '#FFFFFF'   })  
                    		                       }
                    		                       
                    		                       //如多选项Item1有4项，其中第2，3项关联元素Item2,如果选中Item1_2或Item1_3,且Item2的值为空则Item2元素加红色提示必填
                    		                        if ((zkstr1[1]==selectitem)&&(selectitem_id!="")&&(zkstr1[6].indexOf(selectitem_id)>-1)) 
                    		                       {
                    		                       	 var itm2 = document.getElementById(key).value;
                    		                       	 //alert(itm2)
                    		                       	 if (itm2=="")
                    		                       	 {
                    		                       	 var Itemsqm=Ext.fly(key);	
                    		                       	 Itemsqm.setStyle({background: '#FF0000'}) ; 
                    		                         }  
                    		                       }
                    		                    }	
		                   }
	                     //alert(itemmultother)             
	                 }
	                 //alert(flagcheck)
	                 if ((checkval==false)&(selectitem!="")&&(hazkitem.contains(selectitem)))
	                 {
	                 	 var zkstr22=hazkitem.items(selectitem)
                     var zkstr144=zkstr22.split('^')
	                 	 if ((zkstr144[0]=="User")&&(flagcheck==0))
	                 	 {
	                 	 	alert("该项必填，不能都为空！")
	                 	 }
	                 }
	             
	              }
	              )
	           
	         }
}

function KeyDown(e) //获取enter键盘事件响应
 {
      if(document.all)
      {
       var iekey=window.event.keyCode;
       if(iekey==13)
          {   
          	var demostr=demouser.split('^')
          	//alert(demostr)
          	for (i=0;i<demostr.length;i++)
          	{
          		var demoitm=demostr[i]
          		 if(event.srcElement.id==demoitm)
          		 {
          		 	document.getElementById(demoitm).value=session['LOGON.USERNAME'] +"*"+session['LOGON.USERID'];
          		 	
          		 }
          	}
          
          }
       
       }
}

function getval(itm)
{
	var tm=itm.split('!');
//	alert(tm)
	return tm[0];
}

//保存时检测筛选控制
function Savezk()
{
	hasavestr.clear()
	var savestr=ret+"^"+checkret+"^"+comboret
  var savestrs=savestr.split('^')
    
  //alert(savestrs)
  sethashvalue(hasavestr, savestrs);	
	var flagzk=0
	if (hazkitem.keys().length==0) return
	//alert(hazkitem.keys().length)
	//遍历质控项
	 for (var i=0 ; i<hazkitem.keys().length;i++)//for...in statement get all of Array's index
	{
		var key = hazkitem.keys()[i];
		//alert(key)
		
		var zkstr22=hazkitem.items(key)
    var zkstr144=zkstr22.split('^')
	if (zkstr144[1]=="") continue;
		if (key=="") continue
	  var newstr=key+"_"+1
	  var objitm=Ext.getCmp(newstr)	
	  var linkqm=""
	  var linkqm=document.getElementById(zkstr144[1]).value //当前关联签名值	  //关联签名值
	  //alert(linkqm)
	  //1 多选项必填控制			  
	  if ((objitm)&&(linkqm!="")) //关联签名处为空不质控
		{
		 
				var flagif="";
				//alert(zkstr144)
				MultLength=15
				if (haMult.contains(key))
				{
					 MultLength=haMult.items(key)
				}
				if (zkstr144[0]=="Link") //关联类型
				{
				
				               var objselectitm=Ext.getCmp(zkstr1[1])
					             if (objselectitm)
					             {
					                  var selectindex=objselectitm.selectedIndex 
					                  //单选项不许手工选择时判断关联项
					                  if (selectindex!=-1)
					                  {
				                                 selectindex=parseInt(selectindex)+1					                       
					                               var Itemsqm=Ext.fly(key);	
					                               if (selectindex==zkstr1[6])      //找到关联项
					                               {
					                               
					                               }
					                               else
					                               {
					                                   //质控关联项如果没有选择触发项，则其关联的子项（此处是多选）都清空
					                                   for (ii=1;ii<=MultLength;ii++)
				                                     {
				                                             var striss=key+"_"+ii
					                                           var objitmsub=Ext.getCmp(striss)
					                                           if (objitmsub)
					                                           {
					                                               if (objitmsub.checked)
					                                               {
					                                                  //alert(11)
					                                                  objitmsub.setValue(false)
					                                                  //flagif=1; //有某项选中
					                                               }					       
					                                           }				     
			                                       }			
					                               
					                               }
					                  }          
					             }                  
				}
				else
				{
			        for (ii=1;ii<=MultLength;ii++)
				      {
				        var striss=key+"_"+ii
					      var objitmsub=Ext.getCmp(striss)
					      if (objitmsub)
					      {
					          if (objitmsub.checked)
					          {
					             flagif=1; //有某项选中
					          }					       
					      }				     
			        }					     
			         if (flagif==1) //有某项选中
			        {					       
					       var Itemsqms=Ext.fly(newstr);	
					       Itemsqms.setStyle({	            
                 background: '#FFFF00'
                 })    						
				       }
				      else //都没选中
				      {
				         var Itemsqms=Ext.fly(newstr);	
					       Itemsqms.setStyle({	            
                 background: '#EE0000'
                 }) 
                 //alert(newstr)
                 if (zkstr144[5].indexOf('(')>-1)
                 {
                    var alerstr=zkstr144[5].split('(')
                    alert(alerstr[0]+"  必填!")
                 }
                 else
                 {
                    alert(zkstr144[5]+"  必填!")           
                  }
					       return 2;		  
				
				       }
				 }
			
					     
		}
		
	 //遍历所有元素   
   if (hasavestr.contains(key))
		{
			 
				var zkstr=hazkitem.items(key)
				var zkstr1=zkstr.split('^')
				var itm = Ext.getCmp(key);						
				//0User^1 Item关联项^2 Y允许为空^3 N允许修改^4 N本人修改^5 T开始时间^6 num选中第几项时控制关联项^		
				//1 类型是Link,关联签名itm不为空	 
			  if ((zkstr1[0]=="Link")&(zkstr1[1]!=""))  
			  { 		
			      	  //  alert(key)
					  if ((zkstr1[5]!="")&&(zkstr1[6]!=""))
					  {
					  	  
					  	  if (zkstr1[6].indexOf('*')>-1)
					  	  {
					  	  	 var zkstrs=zkstr1[6].split('*');
					  	  	 if (key=="Item67")
					  	  	 {
					  	  	   // alert(zkstrs) 
					  	  	 }
					  	  	 for (i2=0;i2<zkstrs.length;i2++)
					  	  	 {
					  	  	 	  //alert(zkstr1[1]+"^"+zkstrs[i2]+"^"+key)
					  	  	    var retflag=setlinkzk(zkstr1[1],zkstrs[i2],key,1);
					  	  	  
					  	  	    if (retflag==1) 
					  	  	    {
					  	  	    	flagzk=1;
					  	  	    	break
					  	  	    }
					  	  	 }
					  	  }
					  	  else
					  	  {
					  	  	  var retflag=setlinkzk(zkstr1[1],zkstr1[6],key,0);
					  	  	   if (retflag==1) 
					  	  	    {
					  	  	    	flagzk=1;
					  	  	    	
					  	  	    }
					  	  }
					  	 
					       
					  }				
			  }
			  //2 质控项不为空,类型是User
				if ((zkstr1[2]=="N")&&(zkstr1[0]=="User")) //不允许为空
				{
					if ((zkstr1[0]=="User")&(zkstr1[1]!=""))  //类型是User,关联签名itm不为空
					{ 
						//关联签名
						var userval=document.getElementById(zkstr1[1]).value //
						//录入值
						//alert(hasavestr.items(key))
						var keyval=getval(hasavestr.items(key))
						
						if ((userval!="")&(userval.indexOf(session['LOGON.USERID'])==-1)) //A签名下有签名，登录人不是该签名则不判定该签名关联的项
						{
							//alert(key)
							//continue
						  //break
						}
						//alert(userval)
						//alert(keyval)
						/*
						if ((userval=="")) //签名值为空  签名处变红
						{
						  var Itemsqm=Ext.fly(zkstr1[1]);	
						  Itemsqm.setStyle({	            
              background: '#FF0000'
             })    
							//alert("签名不能为空")
							flagzk=1
							return flagzk
						}
						*/
						if ((keyval!="")&(userval=="")) //签名值为空 录入值不为空  签名处变红
						{
						  var Itemsqm=Ext.fly(zkstr1[1]);	
						  Itemsqm.setStyle({	            
              background: '#FF0000'
             })    
							//alert("签名不能为空")
							flagzk=1
							return flagzk
						}
						if(userval!="") //签名值不为空 签名处取消红色
						{
							var Itemsqm=Ext.fly(zkstr1[1]);	
						  Itemsqm.setStyle({	            
              background: '#FFFFFF'
             })    
						}
						//alert(userval)
						if (userval!="") //签名值不为空
						{
					  
					      //alert(keyval)
					  
					     if (keyval=="")
					     {		
					       var Items=Ext.fly(key);			
		             Items.setStyle({	            
                 background: '#FF0000'
               })    
               flagzk=1					
					     }
					     else
					     {
					      var Items=Ext.fly(key);	
						    Items.setStyle({	            
                background: '#FFFFFF'
                })    					
					     }
					  }
					 
				  }			
				}			
				//alert(zkstr)
			}	
	}
	//alert(flagzk)
	return flagzk
	
}
//zk1:要质控的项key的关联元素id(一般是多选元素)
//zk6:关联元素中第几项选中或勾上后质控
//key:要质控的项id
//flag:
//      1,link项多选元素有两个以上项有关联，以*分割
//      0,link项多选元素只有一项有关联
//返回值：1 不允许保存，变红
         // 0 通过
function setlinkzk(zk1,zk6,key,flag)
{
	                var flagzk=0;
	                var itms=zk1+"_"+zk6
					        var objitmsub=Ext.getCmp(itms)
					        //多选元素某个项(zkstr1[6])填了关联项不能为空
					        if (key=="Item67")
					               {
					               	//alert(itms)
					               	}
					        if (objitmsub)
					        {					 
					               var keyval=getval(hasavestr.items(key))   
					               //alert(objitmsub.checked)     
					               
					               if (objitmsub.checked)  //关联项勾上了
					               {				       
					                    var Itemsqm=Ext.fly(key);	
					                    if (keyval=="")
					                    {					                 
						                    Itemsqm.setStyle({	            
                                background: '#FF0000'
                               })    						
							                 flagzk=1					          
					                    }
					                    else //值不为空取消红色
					                    {
					                        Itemsqm.setStyle({	            
                                  background: '#FFFFFF'
                                 }) 					          
					                     }
					                }
					                else  //关联主项没有勾选  取消关联项值及颜色
					                {					
					                	   if (flag==0)   
					                	   {           
					                      var Itemsqm=Ext.fly(key);	
						                    Itemsqm.setStyle({	            
                                background: '#FFFFFF'
                                })    
                               // alert(key)						
							                  Ext.getCmp(key).setValue("")	//key项的关联项未勾上，该项key不允许填值
							                 }	
							                 if ((flag==1)&&(keyval!=""))
							                 {
							                 	 var Itemsqm=Ext.fly(key);	
						                    Itemsqm.setStyle({	            
                                background: '#FFFFFF'
                                }) 
							                 	
							                 }	
							                 		          					             				       
					                 }					       
					          }
					          else
					          {
					             var objselectitm=Ext.getCmp(zk1)
					             if (objselectitm)
					             {
					                  var selectindex=objselectitm.selectedIndex 
					                  if (selectindex!=-1)
					                  {
					                        var zkval=document.getElementById(key).value //关联项值
					                         var itmskey=key+"_1"
					                        // alert(itmskey)
					                        var objkey=Ext.getCmp(itmskey)
					                        if (objkey)
					                        {
					                             
					                        
					                        }
					                        else
					                        {
					                               selectindex=parseInt(selectindex)+1					                       
					                               var Itemsqm=Ext.fly(key);	
					                               if (selectindex==zk6)      //找到关联项
					                               {
					                                  if (zkval=="")
					                                  {  
					                                     Itemsqm.setStyle({background: '#FF0000'}) ;                                                                                                    						
							                                 flagzk=1	
					                                   }
					                                   else
					                                   {
					                                     Itemsqm.setStyle({	 background: '#FFFFFF'  })                                                                            	
					                                   }					                        				                    
					                                 }	
					                               else
					                               { 
					                            
						                           Itemsqm.setStyle({ background: '#FFFFFF'	})   
						                           // alert(key)                                                                           						
							                         Ext.getCmp(key).setValue("")		
							                        
					                         }	
					                         }		                
					                  }
					             }
					          
					          }				 
	
	   return flagzk;
}
//质控项值改变触发的动作
function lisentAdd(obj)
{ 
	 var scorehj=0;
	 var tmp=obj.getValue(); //当前值
	 var idsss=obj.getName();	 //当前Item
	 var zkstr=hazkitem.items(idsss)  //质控数据
	 var zkstr1=zkstr.split('^')
	 
	 if (zkstr1[1]!="") //关联签名不为空
	 {
	 	    var userobj = Ext.getCmp(zkstr1[1]); 
	 	    var userval=document.getElementById(zkstr1[1]).value //当前关联签名值	   
	      if ((zkstr1[0]=="User")) //质控类型为"User"
	      {	   
	         //alert((ha.contains(idsss)))
	   	       if (ha.contains(idsss)) //页面打开加载的数据中签名处已经有值
	           {
	               var ixistval=getval(ha.items(idsss)) //选中元素存在的值
	               var ixistuserval=getval(ha.items(zkstr1[1])) //签名出签名
	                //alert(ixistval+"$"+tmp+"$"+ixistuserval+"$"+ha.items(zkstr1[1])+"$"+userval)
	               if ((ixistval==tmp)&(userval!=ixistuserval)) //修改别人签名的数据后又取消修改，则原来签名不变
	               {
	     	            userobj.setValue(ixistuserval) 
	               }
	                else //修改数据后更新签名
	               { 
	       	         if (session['LOGON.GROUPDESC'].indexOf(demogroudesc)==-1) //不是护士长
	       	         {
	       		          setuser(zkstr1[1]) 
	       	         }
	       	         else //护士长修改数据不修改护士签名
	       	         {
	       	 		        if ((ixistval=="")||(EmrCodeDemo.indexOf(EmrCode)>-1))
	       	 		        {
	       	 			        setuser(zkstr1[1])
	       	 		        }
	       	         }
	               }
	            }
	            else  //新建模板，还未保存过，ha为空
	            {
	     	          if (tmp=="") //选择清空，则清空签名
	     	          {
	     	  	         //userobj.setValue("") 
	     	          }
	     	          else
	     	     	    {
	     	             setuser(zkstr1[1])
	                }
	             }	
	             //如果不为空则取消红色
	             	var itm2 = document.getElementById(idsss).value;
		                       	 //alert(itm2)
		                       	 if (itm2!="")
		                       	 {
		                       	   var Itemsqm=Ext.fly(idsss);	
		                       	   Itemsqm.setStyle({background: '#FFFFFF'}) ; 
		                         } 
		                         if (itm2=="")
		                         {
		                         	 var Itemsqm=Ext.fly(idsss);	
		                       	   Itemsqm.setStyle({background: '#FF0000'}) ;
		                         }
	      }      
	      if (zkstr1[0]=="Link") //质控类型为"Link"
	      {	 
	      	//alert(idsss)
	                           var itm2 = document.getElementById(idsss).value;
		                       	 //alert(itm2)
		                       	 if (itm2!="")
		                       	 {
		                       	   var Itemsqm=Ext.fly(idsss);	
		                       	   Itemsqm.setStyle({background: '#FFFFFF'}) ; 
		                         }  
	      }
	      
	      
				
				               var objselectitm=Ext.getCmp(idsss)
					             if (objselectitm)
					             {
					                  var selectindex=objselectitm.selectedIndex 
					                  //单选项不许手工选择时判断关联项
					                  //单选项有关联项时，如Item1第二项关联Item2元素，当Item1元素选中第二个元素时，Item2元素变红
					                  if (selectindex!=-1)
					                  {
				                                 selectindex=parseInt(selectindex)+1		
				                                 //alert(selectindex)			                       
					                               var Itemsqm=Ext.fly(key);	
					                              
					                                       //多选项变更选择项时查询多选关联项
                         	                     	for (var i=0 ; i<hazkitem.keys().length;i++)//
                         	                      {
                         		                       var key = hazkitem.keys()[i]; 	
                         		                       if (key=="") continue
                         	                         var itm = Ext.getCmp(key); 	   
                         	                         var zkstr=hazkitem.items(key)
                         		                       var zkstr1=zkstr.split('^')
                         		                       if (zkstr1[0]!="Link")	continue //Link元素是关联质控项
                         		                       //alert(key)
                         		                        //找到关联项并且多选项的子项k没有在关联项中维护则清除该项颜色
                         		                       if ((zkstr1[1]==idsss)&&(zkstr1[6].indexOf(selectindex)==-1)) 
                         		                       {
                         		                       	 var Itemsqm=Ext.fly(key);	
                         		                       	 Itemsqm.setStyle({	   background: '#FFFFFF'   })   		                       	 		                       	                                                                    	
                         		                       }
                         		                       if ((zkstr1[1]==idsss)&&(zkstr1[6].indexOf(selectindex)!=-1)) 
                         		                       {
                         		                       	 var Itemsqm=Ext.fly(key);	
                         		                       	 //为空则变红
                         		                       	 var itm2 = document.getElementById(key);
                         		                       	 if (itm2.value=="")
                         		                       	 {
                         		                       	 Itemsqm.setStyle({	   background: '#FF0000'   })
                         		                         }   		                       	 		                       	                                                                    	
                         		                       }
                         		                      
                         		                    }	
					                               
					                  }
					             
					             }
			  
	 }

}
//自动签名
function setuser(itm)
{
	              var val=document.getElementById(itm).value
             	  var vaitm=Ext.getCmp(itm);
             	  var vals=session['LOGON.USERID']    
                if ((val!="")) //签名处值不唯一
                {
                	  if ((val.indexOf(vals)>-1)) //电子签名
             	  	  { if (haqm.contains(itm))
             	  	 		{
             	  	    var arradyval=haqm.items(itm)
             	  	    if (arradyval!=val)
             	  	    {
		                  //alert("不允许修改原来的签名")
		                  vaitm.setValue(arradyval)
		                  return
		                  }
		                  }
             	  	 	 //alert("签名已经存在")
             	  	 	
             	  	 	}
             	  	 	else
             	  	 	{
             	  	 		if (haqm.contains(itm))
             	  	 		{
             	  	        var arradyval=haqm.items(itm)
             	  	        if (arradyval!=val)
             	  	        {
		                       //alert("不允许修改原来的签名")
		                       vaitm.setValue(arradyval)
		                       return
		                      }
		                      document.getElementById(itm).value=session['LOGON.USERNAME'] //谁最后修改签谁的名
                          //document.getElementById(itm).value=document.getElementById(itm).value+"+"+session['LOGON.USERNAME']  //附带签名 +"  "+ session['LOGON.USERCODE']  //+"*"+session['LOGON.USERID'];
                          var but=Ext.getCmp(itm);   
                          //but.disable()
                      }
                    }
                }
                else
             	  {
             	  	
             	  	   if (haqm.contains(itm))
             	  	 		{
             	  	    var arradyval=haqm.items(itm)
             	  	    if (arradyval!=val)
             	  	    {
		                  //alert("不允许修改原来的签名")
		                  vaitm.setValue(arradyval)
		                  return
		                  }	
		                  }	
             		   document.getElementById(itm).value=session['LOGON.USERNAME'] //CA签名用 +"*"+session['LOGON.USERID'];
             		   var but=Ext.getCmp(itm);
                   //but.disable()
             		}
             
	
}


//多次保存评估单取初值
function setvalueMult()
{ 
   //alert(NurRecId);
 ha.clear()
 if(NurRecId!="")
   { 
   	var getVal = document.getElementById('getVal');
   	var ret = cspRunServerMethod(getVal.value, NurRecId);
   //	alert(ret);
   	var tm = ret.split('^')
   	//alert(tm)
		sethashvalue(ha, tm);	
	 var gform=Ext.getCmp("gform");
   gform.items.each(eachItem, this);  	
	for (var i=0 ; i<ht.keys().length;i++)//for...in statement get all of Array's index
	{
		var key = ht.keys()[i];
		if (key.indexOf("_") == -1) 
		{
			
			var flag=ifflag(key );
			if (flag==true)
			{
				if (ha.contains(key)) setVal2(key ,ha.items(key));			
				continue;
			}
			var itm = Ext.getCmp(key);
			if (ha.contains(key)) 
			{
				//alert(key)
			itm.setValue(getval(ha.items(key)));	
		  }	
	   }
	   else
	    {
			var aa=key.split('_');
			 if(ha.contains(aa[0]))
			 {
			  setcheckvalue(key,ha.items(aa[0]));
			 }
		  }
    }
   }
   else
   {
   getPatInfo();	
   }	 
}

//单次保存评估单取初值
function setvalueOnce()
{
	
   //var ha = new Hashtable();
   ha.clear()
   var getid=document.getElementById('GetId');
   var id=cspRunServerMethod(getid.value,EmrCode,EpisodeID);
   //alert(id)
   if (id!="")
   {
   	 var getVal=document.getElementById('getVal');
	   var ret=cspRunServerMethod(getVal.value,id);
     var tm=ret.split('^')	
	   sethashvalue(ha,tm)
   }
 	 else {
 	 	getPatInfo();	
 	 }   
	 var gform=Ext.getCmp("gform");
   gform.items.each(eachItem, this);  	
	for (var i=0 ; i<ht.keys().length;i++)//for...in statement get all of Array's index
	{
		var key = ht.keys()[i];	
		if (key.indexOf("_") == -1) 
		{		
			var flag=ifflag(key );
			if (flag==true)
			{
				setVal2(key ,ha.items(key));		
				continue;
			}
			var itm = Ext.getCmp(key);
			if (ha.contains(key)) 
			itm.setValue(getval(ha.items(key)));			
	    }else{
			var aa=key.split('_');
			if(ha.contains(aa[0]))
			{
			  setcheckvalue(key,ha.items(aa[0]));
			}
		}
    }
 
}
//var configstr2 = cspRunServerMethod(Getloccodezkitems, session['LOGON.CTLOCID'],EmrCode);