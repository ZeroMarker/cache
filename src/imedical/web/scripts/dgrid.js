/*
Desc:
Editor:cwj
*/

//最上的chk的click事件
function chkChange()
{
	var status = document.getElementById('chkTitle').checked;
	sltRows(document.getElementById('EPRList'), 'ckbPrint', status);		//设置按钮全选或全消
	setPower();		//设置权限			add by zhuj on 2009-12-9
	
}

//shift按键
function chkListChange()
{
	setPower();		//设置权限			add by zhuj on 2009-12-9
	if(!window.event.srcElement.checked)
	{
		return;
	}
	if(event.shiftKey)
	{
		//alert(window.event.srcElement.logDocID);
		var list = document.getElementById('EPRList').all['ckbPrint'];		
		//如果只有一条记录
		if (list.length == undefined)
		{
			return;
		}
		
		
		var flag = false;
		var length = list.length;
		for (var i = 0; i < length; i++)
		{
			//判断是否为当前项?若是?则跳出循环
			if (list[i].instanceid == window.event.srcElement.instanceid)
			{
				break;
			}

			if (list[i].checked && !flag)
			{
				flag = true;
			}
			
			if (flag)
			{
				list[i].checked = true;	
			}
		}
		setPower();		//设置权限			add by zhuj on 2009-12-9		
	};
}

//根据列表初始化权限
function initPower()
{
	//将所有权限设置为1
	canView = '1';
  	canSave = '1';
  	canPrint = '1';
  	canCommit = '1';
  	canSwitch = '1';  	
  	
  	canChiefCheck = '1';
  	canAttendingCheck = '1';
  	canExport = '1';
  	
  	
	chkList = $(':checkbox');		//页面上所有的chk
	
	var isNoSelect = true;			//判断是否全部未选中,true为都未选中
	var length = chkList.length;

	for (i = 0; i < length; i++)
	{
		//如果为表头的chk,执行下一次循环		
		if(chkList[i].id == 'chkTitle' || chkList[i].id == 'chkSelectAll')
		{
			continue;
		}		
		if(!chkList[i].checked)
		{
			continue;
		}
		isNoSelect = false;		//判断是否都未选中
		if (canView != '0' && chkList[i].canView == '0')
		{
			canView = '0';
		}
		if (canSave != '0' && chkList[i].canSave == '0')
		{
			canSave = '0';
		}
		if (canCommit != '0' && chkList[i].canCommit == '0')
		{
			canCommit = '0';
		}
		if (canPrint != '0' && chkList[i].canPrint == '0')
		{
			canPrint = '0';
		}
		if (canSwitch != '0' && chkList[i].canSwitch == '0')
		{
			canSwitch = '0';
		}
		if (canChiefCheck != '0' && chkList[i].canChiefCheck == '0')
		{
			canChiefCheck = '0';
		}
		if (canAttendingCheck != '0' && chkList[i].canAttendingCheck == '0')
		{
			canAttendingCheck = '0';        }
        if (chkList[i].canExport == '0') {
            canExport = '0';
        }
		
		//判断如果所有权限都为0,则跳出循环
        if (canView == '0' && canSave == '0' && canCommit == '0' && canPrint == '0' && canSwitch == '0' && canChiefCheck == '0' && canAttendingCheck == '0' && canExport == '0')
		{
			break;
		}
	}
	
	//判断是否都未选中,若是,则将打印、提交、主治审核、主任审核设置为0
	if (isNoSelect == true) {
		canPrint = '0';
  		canCommit = '0';
		canChiefCheck = '0';
		canAttendingCheck = '0';
		canExport = '0';
	}
}


//选中行改变颜色
function choTr(selectedTr,num){
	var trList = document.getElementsByTagName('tr');
	var tdLength = selectedTr.children.length;
	
	if (lastSelectTr != '')
	{
		var curTdList = lastSelectTr.children;
		for(j=0;j < tdLength;j++)
		{
			curTdList[j].style.backgroundColor='#F6FCFD';
		}
	}
	lastSelectTr = selectedTr;
	/*
	for(i=0; i < trList.length; i++)
	{
		if(trList[i].id == "valueTr")
		{
			var curTdList = trList[i].children;
			for(j=0;j < tdLength;j++)
			{
				curTdList[j].style.backgroundColor='#F6FCFD';
			}
		}
	}
	*/
	var sltTdList=selectedTr.children;
	for(j=0;j < tdLength;j++)
	{
		sltTdList[j].style.backgroundColor='#B6C4D0';
	}
	
}

//双击时，去掉返选
function dbChoTr(elem){
	var td=elem.children;
	for(j=0;j<td.length;j++){
		td[j].style.backgroundColor='F6FCFD'
	}
}

//删除选中的所有行
function delTr(id){
	var tablelist = document.getElementById("tablelist");
	var tr = tablelist.rows;
	if(id && id!=''){
		for(i=1;i<tr.length;i++){
			var td=tr[i].cells;
			if(id==td[0].firstChild.value){
				tablelist.deleteRow(i);
			}
		}
	}else{
		var i=1;
		while(i<tr.length){
			var td=tr[i].cells;
			if(td[0].firstChild.checked){
				tablelist.deleteRow(i);
			}else{
				i++;
			}
		}
	}
}

//全选 或 全消所有行
function sltRows(element, checkboxname, ischeck)
{
	var trList = element.all[checkboxname];
	if(trList == undefined)
	{
		return;
	}
	if (trList.length == undefined)
	{
		trList.checked = ischeck;
	}
	var length = trList.length;
	for(i=0; i < length; i++)
	{
		trList[i].checked = ischeck;
	}
	
	

}