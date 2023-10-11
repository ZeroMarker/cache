var ret="";
var checkret="";
var comboret="";
var arrgrid=new Array();



function formatDate(value){
  	try
	{
	   return value ? value.dateFormat('Y-m-d') : '';
	}
	catch(err)
	{
	   return '';
	}
 };
function eachItem1(item,index,length) {   
    if (item.xtype=="datefield") {   
            //修改下拉框的请求地址    
			ret=ret+item.id+"|"+formatDate(item.getValue())+"^";   
			
      
    } 
    if (item.xtype=="timefield") {   
            //修改下拉框的请求地址    
			//debugger;
			ret=  ret+item.id+"|"+item.getValue()+"^";   
      
    } 
	 if (item.xtype=="combo") {   
            //修改下拉框的请求地址    
			//debugger;
			comboret=  comboret+item.id+"|"+item.getValue()+"!"+item.lastSelectionText+"^";   
      
    } 
	 if (item.xtype=="textfield") {   
            //修改下拉框的请求地址    
			//debugger;
			ret=  ret+item.id+"|"+item.getValue()+"^";   
      
    } 
	 if (item.xtype=="textarea") {   
            //修改下拉框的请求地址    
			ret=  ret+item.id+"|"+item.getRawValue()+"^";   
      
    } 
	 if (item.xtype=="checkbox") {   
            //修改下拉框的请求地址    
			//debugger;
			if (item.checked==true)
			{
				 checkret=checkret+item.id+"|"+item.boxLabel+"^"; 
			}
			else
			{			
				 checkret=checkret+item.id+"|^";
			}  
      
    } 
	  
    if (item.items && item.items.getCount() > 0) {   
       item.items.each(eachItem1, this);   
    }   
}
var SubId="";   
var ITypItm=""; //后取数据字典型
function BodyLoadHandler(){
	
	var butSave=Ext.getCmp("SaveBut");
	butSave.on('click',function(){Save(SubId)});
	
	var DepDR=Ext.getCmp("LocList");
	DepDR.allowBlank=true;
	DepDR.pageSize=100;
	
	var grid = Ext.getCmp('mygrid');
	grid.on('rowdblclick',modccevent);
	
	Ext.getCmp('LocList').store.on("beforeLoad",function(){
   	var wardstore=Ext.getCmp('LocList').store;
   	var str=Ext.getCmp("LocList").lastQuery
 		wardstore.baseParams.ward=str; 
  });
	var DepStore=Ext.getCmp("LocList").getStore();
	DepStore.load({
		params:{start:0,limit:100}
	});
	DepDR.on('select', function() {
		var depdr=DepDR.getValue();
		loaddepmodelset(depdr);
		});
	var Moudelobj=Ext.getCmp("MouldList");
	Moudelobj.store.on("beforeLoad",function(){
	 	Moudelobj.store.baseParams.LocId=DepDR.getValue();
	})
	var MoudelobjStore=Ext.getCmp("MouldList").getStore();
	MoudelobjStore.load({
		params:{start:0,limit:10}
	}); 	
	Moudelobj.on('select', function() {
		var RecType=Moudelobj.getValue();
		loadmodelColumns(RecType);
		//Ext.getCmp("RelateItem").setValue("CaseMeasure");
		//Ext.getCmp("RelateItem").setRawValue("病情变化及措施");
		});
	
	//调用键盘事件
	//document.onkeydown=BsKeyDown;
	
	var mygrid=Ext.getCmp("mygrid");
	var but1=Ext.getCmp("mygridbut1");
    but1.setText("删除");
    but1.on('click',function(){delitm(Ext.getCmp("mygrid"));});//诊断删除
    var but=Ext.getCmp("mygridbut2");
    but.hide();
	mygrid.getBottomToolbar().hide();
	loaddepmodelset("9000");
	
	setvalue();
	var RecType=Moudelobj.getValue();
	loadmodelColumns(RecType);

	var len = mygrid.getColumnModel().getColumnCount();
	for(var i = 0 ;i < len;i++){
		if(mygrid.getColumnModel().getDataIndex(i) == 'BaseItemId'){
			mygrid.getColumnModel().setHidden(i,true);
		}
		if(mygrid.getColumnModel().getDataIndex(i) == 'RelateItemId'){
			mygrid.getColumnModel().setHidden(i,true);
		}
		if(mygrid.getColumnModel().getDataIndex(i) == 'rw'){
			mygrid.getColumnModel().setHidden(i,true);
		}
	}
	//window.onbeforeunload=CloseWinAlert;
	//window.on('beforeClose',CloseWinAlert);
}
function loaddepmodelset(locId)
{
	var Moudelobj=Ext.getCmp("MouldList");
	Moudelobj.store.on("beforeLoad",function(){
	 	Moudelobj.store.baseParams.LocId=locId;
	})
	var MoudelobjStore=Ext.getCmp("MouldList").getStore();
	MoudelobjStore.load({
		params:{start:0,limit:10}
	}); 
 	
}
function loadmodelColumns(type)
{
	//加载体征项目
	var BaseItemobj=Ext.getCmp("BaseItem");
	BaseItemobj.store.on("beforeLoad",function(){
	 	BaseItemobj.store.baseParams.EmrCode=type;
	})
	var BaseItemobjStore=Ext.getCmp("BaseItem").getStore();
	BaseItemobjStore.load({
		params:{start:0,limit:10}
	}); 
	//加载评估项目
	var RelateItemobj=Ext.getCmp("RelateItem");
	RelateItemobj.store.on("beforeLoad",function(){
	 	RelateItemobj.store.baseParams.EmrCode=type;
	})
	var RelateItemobjStore=Ext.getCmp("RelateItem").getStore();
	RelateItemobjStore.load({
		params:{start:0,limit:10}
	}); 
 	
}

function additmItm(griditm,desc,idrw)
{
	var grid=Ext.getCmp(griditm);
    var n = grid.getStore().getCount();
       
    var store = grid.store;
 
    for( var j=0;j<n;j++)
    {
       var Diagrw=store.getAt(j).get("Diagrw");
  
       if (Diagrw==idrw)return;
    }
    var Plant = Ext.data.Record.create([
           // the "name" below matches the tag name to read, except "availDate"
           // which is mapped to the tag "availability"

      ]);
                var count = grid.store.getCount(); 
                var r = new Plant({DiagDesc:desc,Diagrw:idrw}); 
                grid.store.commitChanges(); 
                grid.store.insert(count,r); 
                return;

}
function delitm(grid)
{
  var objRow=grid.getSelectionModel().getSelections();
  if (objRow.length == 0) { Ext.Msg.alert('提示', "请选择要删除的记录!"); return; }
  else
  {
	var rw=objRow[0].get("rw");
    if((rw!="")||(rw!=undefined))
	{
	  var DelRec=document.getElementById('DelRec');
      var retval=cspRunServerMethod(DelRec.value,NurRecId,rw);	
	}		
  }
  grid.store.remove(grid.getSelectionModel().getSelected());
}
function btclose()
{
	window.close();
}
function modccevent()
{
	var grid=Ext.getCmp("mygrid");
	var objRow=grid.getSelectionModel().getSelections();
	if (objRow.length == 0) {
		return;
	}
	else {
		SubId = objRow[0].get("rw");
		var BaseItem2=objRow[0].get("BaseItem2");
		var BaseVal2 = objRow[0].get("BaseVal2");
		var Conditions2=objRow[0].get("Conditions2");
		var RelateItem2 = objRow[0].get("RelateItem2");
		var RelateVal2=objRow[0].get("RelateVal2");
		var BaseItemId = objRow[0].get("BaseItemId");
		var RelateItemId=objRow[0].get("RelateItemId");
		Ext.getCmp("BaseItem").setValue(BaseItemId);
		Ext.getCmp("BaseItem").setRawValue(BaseItem2);
		Ext.getCmp("BaseVal").setValue(BaseVal2);
		Ext.getCmp("Conditions").setValue(Conditions2);
		Ext.getCmp("RelateItem").setValue(RelateItemId);
		Ext.getCmp("RelateItem").setRawValue(RelateItem2);
		Ext.getCmp("RelateVal").setValue(RelateVal2);
	}
	//finddiaglist(NurRecId);
}
function cmbkey(field, e)
{
	if (e.getKey() ==Ext.EventObject.ENTER)
	{
		var pp=field.lastQuery;
		getlistdata(pp,field);
	//	alert(ret);
		
	}
}
var person=new Array();
function getlistdata(p,cmb)
{
	var GetPerson =document.getElementById('GetPerson');
	//debugger;
    var ret=cspRunServerMethod(GetPerson.value,p);
	if (ret!="")
	{
		var aa=ret.split('^');
		for (i=0;i<aa.length;i++)
		{
			if (aa[i]=="" ) continue;
			var it=aa[i].split('|');
			addperson(it[1],it[0]);
		}
		//debugger;
		cmb.store.loadData(person);
	}
}
function addperson(a,b)
{
	person.push(
	{
		desc:a,
		id:b
	}
	);
}


function AddRec(str)
{
	//var a=new Object(eval(str));
	var obj = eval('(' + str + ')');
	arrgrid.push(obj);
	//debugger;
}
function setvalue()
{
   if (NurRecId != "") 
   {
   	var getVal = document.getElementById('getVal');
   	var ret = cspRunServerMethod(getVal.value, NurRecId);
	if(ret!="")
	{
   	  var tm = ret.split('^');
	  Ext.getCmp("LocList").setValue(tm[0]);
	  Ext.getCmp("LocList").setRawValue(tm[4]);
	  Ext.getCmp("MouldList").setValue(tm[1]);
	  Ext.getCmp("MouldList").setRawValue(tm[2]);
	  
    }
	finddiaglist(NurRecId);
   }
}
function getval(itm)
{
	var tm=itm.split('!');
//	alert(tm)
	return tm[0];
}
function ifflag(itm)
{ //alert(tm);
	var tm=ITypItm.split('|');
	//alert(tm);
	var flag=false;
	for (var i=0;i<tm.length;i++)
	{
		if (itm==tm[i])
		{
			flag=true;
		}
	}
	return flag ;
}
function CloseWinAlert()
{
	/* alert(22)
	Ext.Msg.show({    
	       title:'再确认一下',    
	       msg: '是否需要再次保存再关闭窗口？以防止数据丢失',    
	       buttons:{"ok":"确定","cancel":"取消"},
	       fn:  function(btn, text){    
	            if (btn == 'ok'){   
	            Save();
	            }
				else
	            { }
	            
	        },    
	       animEl: 'newbutton'   
	    }); */
	Ext.Msg.confirm('系统提示','是否需要再次保存再关闭窗口？以防止数据丢失',
      function(btn){
        if(btn=='yes'){
          Save();							
        }else{
          
        }
        
      },this);	
}
function Save()
{
  var DepDR=Ext.getCmp("LocList");
  var LocId=DepDR.getValue();
  if(LocId=="")
  {
	  alert("病区不能为空！");
	  return;
  }
  var Tempobj=Ext.getCmp("MouldList");
  var Emrdesc=Tempobj.getRawValue();
  var RecType=Tempobj.getValue();
  if(RecType=="")
  {
	alert("模板不能为空！");
	return;
  }
  var BaseItemobj=Ext.getCmp("BaseItem");
  var BaseItem=BaseItemobj.getValue();
  if(BaseItem=="")
  {
	  alert("体征项目不能为空！");
	  return;
  }
  var BaseValobj=Ext.getCmp("BaseVal");
  var BaseVal=BaseValobj.getValue();
  if(BaseVal=="")
  {
	  alert("体征值不能为空！");
	  return;
  }
  var Conditionsobj=Ext.getCmp("Conditions");
  var Conditions=Conditionsobj.getValue();
  if(Conditions=="")
  {
	  alert("条件不能为空！");
	  return;
  }
  var RelateValobj=Ext.getCmp("RelateVal");
  var RelateVal=RelateValobj.getValue();
  if(RelateVal=="")
  {
	  alert("评估内容不能为空！");
	  return;
  }
  var RelateItemobj=Ext.getCmp("RelateItem");
  var RelateItem=RelateItemobj.getValue();
  if(RelateItem=="")
  {
	  Ext.Msg.confirm('系统提示','评估项目为空，默认评估项目关键字为"CaseMeasure",是否继续?',
      function(btn){
        if(btn=='yes'){
          var parm=LocId+"^"+Emrdesc+"^"+RecType+"^"+NurRecId;
		  var SaveRec=document.getElementById('Save');
		  var rowid=cspRunServerMethod(SaveRec.value,parm);
		  if(rowid!="") 
			{
			var parr=BaseItem+"^"+BaseItemobj.getRawValue()+"^"+BaseVal+"^"+Conditions+"^CaseMeasure^病情变化及措施"+"^"+RelateVal+"^"+SubId;
			var SubRecSave=document.getElementById('SaveSub');
			var subid= cspRunServerMethod(SubRecSave.value,parr,rowid);	
			alert("保存成功!");
			NurRecId=rowid;
			finddiaglist(rowid);
			cleardata();
			}							
        }else{
          
        }
        
      },this);	
  }
  else
  {
	var parm=LocId+"^"+Emrdesc+"^"+RecType+"^"+NurRecId;
	var SaveRec=document.getElementById('Save');
	var rowid=cspRunServerMethod(SaveRec.value,parm);
	if(rowid!="") 
		{
			var parr=BaseItem+"^"+BaseItemobj.getRawValue()+"^"+BaseVal+"^"+Conditions+"^"+RelateItem+"^"+RelateItemobj.getRawValue()+"^"+RelateVal+"^"+SubId;
			//alert(parr)
			var SubRecSave=document.getElementById('SaveSub');
			var subid= cspRunServerMethod(SubRecSave.value,parr,rowid);	
			alert("保存成功!");
			NurRecId=rowid;
			finddiaglist(rowid);
			cleardata();
		}	  
  }
  
}
function SaveSub(par)
{
	var mygrid=Ext.getCmp("mygrid");
	var store = mygrid.store; 
	var list=[];
	for (var i = 0; i < store.getCount(); i++) {
		list.push(store.getAt(i).data);
	}
	var SubRecSave=document.getElementById('SaveSub');
	for (var i = 0; i < list.length; i++) {
	  var obj=list[i];
	  var rw=obj["rw"];
	  for (var p in obj) 
	  {
		var diagid="";
		
        if(p=="Diagrw") diagid=obj[p];
		if((rw=="")||(rw==undefined))
		{
        var subid= cspRunServerMethod(SubRecSave.value,diagid,par);	
		}		
	  }
	}
}
var REC = new Array();
function finddiaglist(par)
{  
	REC = new Array();
	SubId="";
	var gridobj=Ext.getCmp("mygrid");
	var GetQueryData = document.getElementById('GetQueryData');
	var a = cspRunServerMethod(GetQueryData.value, "web.DHCNurLifeSignRelated:GetConditionsRecComm", "par$" + par, "AddRec");
	gridobj.store.loadData(REC);
}
function AddRec(str)
{
	var obj = eval('(' + str + ')');
	REC.push(obj);
}
function cleardata()
{
		Ext.getCmp("BaseItem").setValue("");
		Ext.getCmp("BaseItem").setRawValue("");
		Ext.getCmp("BaseVal").setValue("");
		Ext.getCmp("Conditions").setValue("");
		Ext.getCmp("RelateItem").setValue("");
		Ext.getCmp("RelateItem").setRawValue("");
		Ext.getCmp("RelateVal").setValue("");
}
