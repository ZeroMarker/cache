/*
Desc:
Editor:cwj
*/

//最上的chk的click事件
function chkChange()
{
	var status = document.getElementById('chkTitle').checked;
	sltRows(document.getElementById('EPRList'), 'ckbPrint', status);		//设置按钮全选或全消
	
}

//shift按键
function chkListChange()
{
	
	
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
		for (var i = 0; i < list.length; i++)
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
	};
}




//选中行改变颜色
function choTr(selectedTr,num){
	var trList = document.getElementsByTagName('tr');
	var tdLength = selectedTr.children.length;
	
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
		td[j].style.backgroundColor='white'
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
	for(i=0; i < trList.length; i++)
	{
		trList[i].checked = ischeck;
	}

}