//设备计数器
var Component="tDHCEQCCounter"  //add by lmm 2018-10-10 hisui改造：定义组件名
function BodyLoadHandler() 
{  
    initPanelHeaderStyle() //added by LMH 20230210 UI 极简组件界面面板标题样式
    initButtonColor(); //added by LMH 20230210 UI 初始化按钮颜色
	initButtonWidth();  //add by lmm 2018-09-05 hisui改造：修改按钮长度
	InitUserInfo();
	//InitEvent();     //modify by lmm 2018-10-18 hisui改造：暂不调用
	//SetDisable();    //modify by lmm 2018-10-18 hisui改造：暂不调用
}

function InitEvent()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCCounter');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	for (i=1;i<rows;i++)
	{		
		var obj=document.getElementById("TGroupFlagz"+i);
		if (obj) obj.onclick=BGroupFlag_Click;
	}
	
}
///modify by lmm 2018-10-10
///描述：hisui改造：重写更新方法列数据获取
function BUpdate_Click()
{
	var rows = $('#'+Component).datagrid('getRows');
	var RowCount=rows.length
	if(RowCount<=0){
		jQuery.messager.alert("没有待保存数据");
		return;
	}
	
		var combindata="";
	for (i=0;i<RowCount;i++)
	{
		if($('#'+Component).datagrid('getEditor',{index:i,field:'TGroupFlag'}).target.checkbox("getValue")==true)
		{
			var TGroupFlag=1
		}
		else
		{
			var TGroupFlag=0
			
		}
		combindata=combindata+"^"+rows[i].TRowID;
		combindata=combindata+"^"+$('#'+Component).datagrid('getEditor',{index:i,field:'TCounterNum'}).target.val();  //值
		combindata=combindata+"^"+rows[i].TypeDR;       //描述
		combindata=combindata+"^"+$('#'+Component).datagrid('getEditor',{index:i,field:'TLength'}).target.val();      //备注
		combindata=combindata+"^"+$('#'+Component).datagrid('getEditor',{index:i,field:'TPrefix'}).target.val();		//前缀
		combindata=combindata+"^"+$('#'+Component).datagrid('getEditor',{index:i,field:'TSuffix'}).target.val();   		//后缀
		combindata=combindata+"^"+TGroupFlag            //是否分组
		combindata=combindata+"^"+$('#'+Component).datagrid('getEditor',{index:i,field:'TGroup'}).target.val();		//分组字符串
		combindata=combindata+"^"+rows[i].THold1;		//保留1
		combindata=combindata+"^"+rows[i].THold2;		//保留2
		combindata=combindata+"^"+rows[i].THold3;		//保留3
		combindata=combindata+"^"+";"
	}
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',combindata);
	if (gbldata!=0)
	{
		messageShow("","","",t[-2201])
		return
	}
	else
	{
		location.reload();
	}
}
function BGroupFlag_Click()
{
	var i=GetTableCurRow();
	var obj=document.getElementById("TGroupFlagz"+i);
	if (obj.checked==true)
	{
		DisableElement("TCounterNumz"+i,true)
		DisableElement("TGroupz"+i,false)
	}
	else
	{
		DisableElement("TCounterNumz"+i,false)
		DisableElement("TGroupz"+i,true)
	}
	
}
function SetDisable()
{	
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCCounter');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var combindata="";
	for (i=1;i<rows;i++)
	{		
		var GroupFlag=GetChkElementValue("TGroupFlagz"+i)
		if (GroupFlag==true)
		{
			DisableElement("TCounterNumz"+i,true)
		}
		else
		{
			DisableElement("TGroupz"+i,true)
		}
	}
}

///add by lmm 2018-10-10
///hisui改造：增加可编辑列表按钮
$('#'+Component).datagrid({
	toolbar:[{  
		iconCls: 'icon-save', 
        text:'保存',          
        handler: function(){
            BUpdate_Click();
        }  
    }],
})

document.body.onload = BodyLoadHandler;
