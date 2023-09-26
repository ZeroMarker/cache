//DHCDocDiagnosSignSymptomAlias
var ary =new Array();
var arytxt=new Array();
var aryval=new Array();
function DocumentLoadHandler() 
{ var obj=document.getElementById('DSYMRowId');
  if(obj) var DSYMrowid=obj.value;
  if(DSYMrowid!="")
  {
  	var obj7=document.getElementById('getAlias');
		if(obj7) 
		{	var encmeth=obj7.value;
    	var ref=cspRunServerMethod(encmeth,DSYMrowid)
			if(ref!="")
			//清空用于存储别名信息的数组
	 			{ary.length=0;
	 			 arytxt.length=0;
	 			 aryval.length=0;
	   	 	 ary=ref.split("%");
	   	 	 AddItemToList.cla
				if(ary[0]!="")arytxt=ary[0].split("^");
				if(ary[1]!="")aryval=ary[1].split("^");
  			if((arytxt!=null)&&(aryval!=null))
  		//向别名列表中添加取出的别名
  			var obj8=document.getElementById('DSYMAAlias');
     	  if(obj8.length!=0) 
     	  obj8.length=0;
     	  AddItemToList(obj8,arytxt,aryval);
     	 }
    }
  }
  else
  {alert(t['selectwarn']);
  	return;
  }
	var obj=document.getElementById('DSYMAAlias')
	if(obj) obj.onchange=List_onClick;
	var obj=document.getElementById('addAlias')
	if(obj) obj.onclick=BADDAlias_click;
	var obj=document.getElementById('delAlias')
	if(obj) obj.onclick=BDeleteAlias_click;
	var obj=document.getElementById('return')
	if(obj) obj.onclick=wclose;
}
function wclose()
{
   window.close();	
}
//增加别名项到List中
function AddItemToList(obj,arytxt,aryval) 
{
	if (arytxt.length!=0) 
	{
		if (arytxt[0]=="") 
		 {
			 for (var i=1;i<arytxt.length;i++) 
			 	{ obj.options[i-1] = new Option(arytxt[i],aryval[i]); 
			 		
			 	}
		 }
	}
}

//选择List中的item到Text编辑框
function ListItemToText(ListFrom,toObj,toObj2) 
{ if(ListFrom.options&&ListFrom.options.length>0)
		{for (var j=0; j<ListFrom.options.length; j++) 
			{
				var opt = ListFrom.options[j];
				if (opt.selected) 
					{
						toObj.value=opt.text;
						toObj2.value=opt.value;
					}
			}
		}
}
//双击list中的item时的响应操作
function List_onClick()
{  var obj=document.getElementById('DSYMAAlias')
   if(obj) 
   		var list=obj;
   var obj=document.getElementById("aliasU")
	 		obj.value=""
   var obj1=document.getElementById("AliasID")
	 		obj1.value=""
	 ListItemToText(list,obj,obj1);
}
//新增别名
function BADDAlias_click()
{ //取得父表的rowid
	var obj=document.getElementById('DSYMRowId')
	if(obj) 
			var DSYMRowId=obj.value;
	if(DSYMRowId=="")
	  { return;
			alert(t['selectwarn']) 
			return;
		}
	//取得别名编辑框中输入的新别名
	var obj=document.getElementById('aliasU')
	if(obj) 
			var aliasU=obj.value;
	if(aliasU=="")
	  {
			alert(t['aliasinput']) 
			return;
		}
	//通过隐藏元素addSignSymptomAlias调用后台类方法
	var obj=document.getElementById('addSignSymptomAliass')
	if(obj) 
			{var encmeth=obj.value;
			 var ref=cspRunServerMethod(encmeth,DSYMRowId,aliasU);
			 if (ref=='-1')
					{	alert(t['addafail']);
					return;
					}	
			 else 
					{	//取得别名的rowid并分割出childsubid
						
					var aliasid=ref.split("||");
					//alert(aliasid[1])	   
	    		var obj=document.getElementById('DSYMAAlias')
	    		AddSingleItemToList(obj,aliasU,aliasid[1]);
	    		var obj=document.getElementById("aliasU")
	    		if(obj) 
	    			obj.value="";
	    			return;
					} 
			} 
}
//删除别名操作
function BDeleteAlias_click()
{
	
	var obj=document.getElementById('DSYMRowId')
	if(obj) var DSYMRowId=obj.value;
	if(DSYMRowId==""){
		alert(t['selectwarn']) 
		return;
		}
	var obj=document.getElementById('AliasID')
	if(obj) var AliasID=obj.value;
	if(AliasID==""){
		alert(t['aliasselect']) 
		return;
		}
	var obj=document.getElementById('delSignSymptomAlias')
	if(obj) 
			var encmeth=obj.value;
	if (cspRunServerMethod(encmeth,DSYMRowId,AliasID)!='0')
		{
			alert(t['delafail']);
			return;
		}	
	else
		{try {var obj=document.getElementById("aliasU")
	     		obj.value=""
       		var obj1=document.getElementById("AliasID")
	     		obj1.value=""
		 	 		clearListItem();
		 			alert(t['delasuccess']);
	    
		 		 } catch(e) {};
	  }
}
//向List列表中添加单个item元素
function AddSingleItemToList(obj,txt,val)

{ 
	if(obj.options)
		{ 
				obj.options[obj.options.length] = new Option(txt,val);	
		}
}
//清空List
function clearListItem()
{ var obj=document.getElementById('DSYMAAlias')
	if(obj.options&&obj.options.length>0)
		for (var i=obj.options.length-1; i>=0; i--) 
		{
			if (obj.options[i].selected) obj.options[i] = null;
		}
}
document.body.onload=DocumentLoadHandler;