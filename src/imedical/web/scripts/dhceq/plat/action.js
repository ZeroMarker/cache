/**
 * @file 动作定义
 * @author 陈建冲
 * @createdate 2022-07-25
 */
var Columns=getCurColumnsInfo('Plat.G.Action','','','','','','');  //modified by LMH 20220914 2896679   //modified by LMH 20221009 2896679
var SelectedRow = -1 ; 
$(function(){
	initDocument();
});
///初始化界面
function initDocument()
{
	initUserInfo();
	initMessage();
	defindTitleStyle(); //默认Style
	initLookUp();
	initButton();
	initButtonWidth();
	setRequiredElements("ACode^ADesc^ASourceType")//验证框设置
	muilt_Tab();  // 回车下一输入框
	
	initActionGrid();

	disabled(true);	
}

function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}

function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}

//加载表格，用于页面初始化以及查询时
function initActionGrid()
{	
		ActionGrid = $HUI.datagrid("#DHCEQCAction",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.CTAction",
			QueryName:"Action",
			Code:getElementValue("ACode"),
			Desc:getElementValue("ADesc"),
			Remark:getElementValue("ARemark"),
			SourceTypeID:getElementValue("ASourceTypeDR")
		},
		fit:true,
		border:false,
		fitColumns:true,
	    singleSelect:true,
	    rownumbers: true, 
	    columns:Columns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],
		
	    onClickRow:function(rowIndex, rowData){
		    OnClickRow(rowIndex,rowData);
		},
		onLoadSuccess:function(jsondata){
			
		}
	});
}

// 数据查询事件
function BFind_Clicked()
{
	initActionGrid();
}

//数据添加与保存
function BSave_Clicked() 
{	
	if (checkMustItemNull()) return;
	var data=getInputList();
	data["ASourceType"]=getElementValue("ASourceTypeDR"); //对data数组添加ASourceType属性
	data=JSON.stringify(data);
    var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTAction","SaveData",data,"0");
	jsonData=JSON.parse(jsonData)
	if ((jsonData.SQLCODE==0))
	{
		
		jQuery('#DHCEQCAction').datagrid('reload');
		alertShow("保存成功");
	}
	else{
		alertShow("错误信息:"+jsonData.Data);
		return
	}	
}

//数据删除
function BDelete_Clicked() 
{
	var RowID=getElementValue("ARowID");
	if (RowID==""){
            $.messager.popover({msg:"请选择一行",type:'alert'}); 
            return false;
    } 
    $.messager.confirm('请确认', '您确定要删除所选的行？', function (b) { 
    	if (b==false)
    	{
        	 return;
   	 	}
    	else
    	{
			var jsonData=tkMakeServerCall("web.DHCEQ.Plat.CTAction","SaveData",RowID,"1");
			jsonData=JSON.parse(jsonData)
			if (jsonData.SQLCODE==0)
			{
				
				jQuery('#DHCEQCAction').datagrid('reload');
				
				alertShow("删除成功");
			}
			else{
				alertShow("错误信息:"+jsonData.Data);
				return
			}
    	}       
  })
}

function BClear_Clicked()
{	
	setElement("ARowID","");
	setElement("ASourceType","");
	setElement("ACode","");
	setElement("ADesc","");
	setElement("ARemark","");
	setElement("ASourceTypeDR","");
}

//点击行事件
function OnClickRow(index,rowdata)
{	
	if (SelectedRow==index){
		BClear_Clicked();
		disabled(true);	
		SelectedRow=-1;
		$('#DHCEQCAction').datagrid('unselectAll');  
	}else{
		
		SelectedRow=index;
		setElement("ARowID",rowdata.TRowID);
		setElement("ASourceType",rowdata.TSourceType);
		setElement("ASourceTypeDR",rowdata.TSourceTypeID);
        setElement("ACode",rowdata.TCode);
        setElement("ADesc",rowdata.TDesc);
        setElement("ARemark",rowdata.TRemark);
		disabled(false);
	}
}

//按钮灰化
function disabled(value)
{
	if (getElementValue("ReadOnly")==1){
		disableElement("BDelete",true)
	}else{
		disableElement("BDelete",value)
	}
}
