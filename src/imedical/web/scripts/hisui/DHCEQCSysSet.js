//设备系统配置表
var Component="tDHCEQCSysSet"  //add by lmm 2018-09-05 hisui改造：定义组件名
function BodyLoadHandler() 
{	
	InitUserInfo();
	initButtonWidth();  //add by lmm 2018-09-05 hisui改造：修改按钮长度
	$('#'+Component).datagrid({
		onClickRow:function (rowIndex, rowData) {
		    if (rowData.TCode!="990018")
		    {
			    $('#'+Component).datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
		    }
		    else
		    {
			    ///FTP独立维护窗口
			    var url='dhceq.plat.ftpserver.csp?';
			    showWindow(url,"FTPServer配置","","6row","icon-w-paper","modal","","","small"); //modify by lmm 2020-06-05 UI
		    }
			},
		onLoadSuccess:function(){}		
	})
}
///modify by lmm 2018-09-05
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
		$('#'+Component).datagrid('selectRow', i).datagrid('endEdit', i);
		//FTP服务器参数要求加密因此需要双击界面单独维护.
		if (rows[i].TCode!="990018")
		{
			combindata=combindata+"^"+rows[i].TRowID;
			combindata=combindata+"^"+rows[i].TValue; ;//值
			combindata=combindata+"^"+rows[i].TDesc; ;//描述
			combindata=combindata+"^"+rows[i].TRemark; ;//备注
			combindata=combindata+"^"+rows[i].TAddValue; ;//值
			combindata=combindata+"^"+"$$"  //modify by lmm 2020-02-25 1198217  数据使用;且常见，故改为$$
		}
	}		
	var len=RowCount+1	
	SetData(combindata,len);//调用函数	
}
function SetData(combindata,rows)
{
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',combindata,rows);
	var plist=gbldata.split("^");
    location.reload();
}
///add by lmm 2018-10-28
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