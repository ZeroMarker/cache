

//js名称:DHCPECommon.hisui.js

//add by xy 2019-05-27
///描述：hisui获取默认当天时间 
function getDefStDate(space) {
	if (isNaN(space)) {
		space = -30;
	}
	var dateObj = new Date();
	dateObj.setDate(dateObj.getDate() + space);
	var myYear = dateObj.getFullYear();
	var myMonth = (dateObj.getMonth() + 1) < 10 ? "0" + (dateObj.getMonth() + 1) : (dateObj.getMonth() + 1);
	var myDay = (dateObj.getDate()) < 10 ? "0" + (dateObj.getDate()) : (dateObj.getDate());
	var dateStr = "";
	var sysDateFormat = $.m({
			ClassName: "websys.Conversions",
			MethodName: "DateFormat"
		}, false); //同步调用取系统配置日期格式
	if (sysDateFormat == 1) {
		dateStr = myMonth + '/' + myDay + '/' + myYear;
	} else if (sysDateFormat == 3) {
		dateStr = myYear + '-' + myMonth + '-' + myDay;
	} else {
		dateStr = myDay + '/' + myMonth + '/' + myYear;
	}

	return dateStr;
}
///add by xy 2020-03-13
///描述：组件hisui改造 列表中checkbox元素不能编辑
///入参: ComponentName: 组件名 Item:图标所在的元素名
function DiaabledTableIcon(ComponentName,Item)
{ 
	if ((ComponentName=="")||(Item=="")) return;
	ComponentName="t"+ComponentName;
    var objtbl = $("#"+ComponentName).datagrid('getRows');
   	var rows=objtbl.length
    for (i=0;i<rows;i++)
    {
	    
		var panel = $("#"+ComponentName).datagrid("getPanel");
		var index=i
			$(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+Item+"]").children().attr("disabled", true);

    }
	
}


///add by xy 2018-09-07
///描述：hisui改造 隐藏表格图标，多用于隐藏合计行图标 
///入参: ComponentName:	组件名    val:对应元素值为空则隐藏该图标   Item:图标所在的元素名
function hiddenTableIcon(ComponentName,val,Item)
{   
	if ((ComponentName=="")||(val=="")||(Item=="")) return;
	ComponentName="t"+ComponentName;
    var objtbl = $("#"+ComponentName).datagrid('getRows');
   	var rows=objtbl.length
    for (i=0;i<rows;i++)
    {
	    
		var panel = $("#"+ComponentName).datagrid("getPanel");
		var index=i
		var obj = panel.find(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+val+"] div");
		if (obj.html()=="")
		{
			$(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+index+"] td[field="+Item+"]").children().hide()  //解决html("")无法隐藏CheckBox的问题

		}
    }
	
}


///add by xy 2018-09-06
///描述：hisui改造  按钮灰化/启用处理
///入参:vElementID 元素名称,vValue:true 灰化 启用 
function DisableBElement(vElementID,vValue)
{ 
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		if (vValue==true)
		{
			//按钮灰化
			jQuery("#"+vElementID).linkbutton("disable")
		
		}
		else
		{
			//按钮启用
			jQuery("#"+vElementID).linkbutton("enable")
			
		}
	}
}


///add by xy 2018-09-05
///描述：hisui改造  按钮名称修改
///入参:ename  元素名称,evalue  待修改的值
function SetCElement(ename,evalue)
{
	
	var obj;
	obj=document.getElementById(ename);
	if(obj){jQuery("#"+ename).linkbutton({text:evalue});}
}

///add by xy 2018-09-04
///描述：hisui改造 按钮最短长度为四字，根据最长按钮调整所有按钮长度
///入参:vExcludesids 初始化除外元素 格式"元素名1,元素名2,....元素名n"
function initButtonWidth(vExcludesids,minlen,subwidth)
{
	
	var minlen=4//最短宽度 四字长 116px
	var subwidth="140px"  
	var middlelen=""
	var IdArr=[];
	//遍历按钮id存入数组
	$(".hisui-linkbutton").each(function(){
		var id=$(this).attr("id");
		//console.log(id);
		IdArr.push(id)
		
	})
	
	for(i=0;i<IdArr.length;i++)
	{
		var len=getValueById(IdArr[i]).length
		if (middlelen=="")
		{
			var middlelen=minlen
		}
		if(len>middlelen)
		{
			var middlelen=len
			var subwidth=$("#"+IdArr[i]).css("width")
		}
		
	}
	for(i=0;i<IdArr.length;i++)
	{
		if ((","+vExcludesids+",").indexOf(","+IdArr[i]+",")==-1)
		{
			$("#"+IdArr[i]).css({"width":subwidth})
		}
		
	}
	
}	
///add by wgy 2020-03-26
///描述：组件hisui改造 列表中checkbox元素不能编辑
///入参: ComponentName: 组件名 Item:图标所在的元素名
function DisabledTableCheckbox(ComponentName,Item)
{ 
	if ((ComponentName=="")||(Item=="")) return;
	ComponentName="t"+ComponentName;
    var objtbl = $("#"+ComponentName).datagrid('getRows');
   	var rows=objtbl.length
    for (i=0;i<rows;i++)
    {
	    
		var panel = $("#"+ComponentName).datagrid("getPanel");
		//$(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+i+"] td[field="+Item+"] .datagrid-cell input[type=checkbox]").attr("disabled", "disabled");
		var checkObj=$(".datagrid-view2 tr.datagrid-row[datagrid-row-index="+i+"] td[field="+Item+"] .datagrid-cell td")[0];
		if(checkObj){
			var checked="";
			if(checkObj.children[0] && checkObj.children[0].value=="1"){
				checked="checked";
			}
			var oldContent=checkObj.innerHTML;
			var newContent=oldContent.replace("<input","<input disabled "+checked);
			checkObj.innerHTML=newContent;
		}
		
    }
	
}	
function PEURLAddToken(url) {
    return 'function' === typeof websys_writeMWToken ? websys_writeMWToken(url) : url;
}