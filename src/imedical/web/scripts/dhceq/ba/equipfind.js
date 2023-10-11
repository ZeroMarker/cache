Array.prototype.indexOf = function(val) {
	for (var i = 0; i < this.length; i++) {
		if (this[i] == val) return i;
	}
	return -1;
};
Array.prototype.remove = function(val) {
	var index = this.indexOf(val);
	if (index > -1) {
		this.splice(index, 1);
	}
};
var fileview = $.extend({}, $.fn.datagrid.defaults.view, { onAfterRender: function (target) { isselectItem(); } });
var selectItems = new Array();
var columns=getCurColumnsInfo('BA.G.BenefitEquipList.GetBenefitEquip','','','','N');  /// 修复页面不显示输出列
var frozencolumns=getCurColumnsInfo('BA.G.BenefitEquipList.GetBenefitEquip','','','','Y');  /// 修复页面不显示输出列
var nameConditionLimit=1   
var conditionFlag=0;  
jQuery(document).ready
( 
	function()
	{

		setTimeout("initDocument();",50);
	}
);
function initDocument()
{
	initTopPanel();
	initStatusData();	
}
//初始化查询头面板
function initTopPanel()
{
	//数值元素定义onchange事件,可校验有效性
	initNumElement("MinValue^MaxValue");
	initLookUp();
	initButtonWidth();
	initButton();
	defindTitleStyle();
	if (getElementValue("UseLocDR")!="")
    {
	    var UseLoc=tkMakeServerCall("web.DHCEQCommon","GetTrakNameByID",'dept',getElementValue("UseLocDR"));
	    setElement("UseLoc",UseLoc)
	}
	initDHCEQEquipList();			//初始化表格
}

function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
}
function clearData(elementID)
{
	setElement(elementID+"DR","")
}
/// 状态下拉框增加全部状态
function initStatusData()
{
	var Status = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '全部'
			},{
				id: '0',
				text: '在库'
			},{
				id: '1',
				text: '启用'
			},{
				id: '2',
				text: '停用'
			}]
	});
}

function initNumElement(vElements)
{
	var ElementInfo=vElements.split("^");
	for(var i=1; i<=ElementInfo.length; i++)
	{
		var CurElement=ElementInfo[i-1]
		if (jQuery("#"+CurElement).prop("type")!="hidden")
		{
			jQuery("#"+CurElement).change(function(){NumChange(CurElement)});

		}
	}
}
function NumChange(vElementID)
{
	var ElementValue=jQuery("#"+vElementID).val();
	if ((ElementValue!="")&&(isNaN(ElementValue)))
	{
		messageShow('popover','error','提示',"请正确输入数值!")
		return
	}
}
function initDHCEQEquipList()
{
	$HUI.datagrid("#tDHCEQBenefitEquip",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.BA.BUSBenefitEquipList",   
	        QueryName:"GetBenefitEquip",
	        Data:"^InitFlag=Y",	
	        ReadOnly:getElementValue("ReadOnly"),
	        //Ejob:getElementValue("Job"),    // 台账添加job对多用户进行限制
	    },
	    fit:true,
		striped : true,
	    cache: false,
		fitColumns:false,		
    	columns:columns, 
    	frozenColumns:frozencolumns,
		pagination:true,
		pageSize:12,
		pageNumber:1,
		pageList:[12,24,36,48],
    	toolbar:"", 
    	// 背景颜色
    	rowStyler: function(index,row){
			return 'background-color:'+row.TBackgroundColor;
		},
});
}
/***************************************按钮调用函数*****************************************************/
function BFind_Clicked()
{
	var lnk=GetLnk()
	$HUI.datagrid("#tDHCEQBenefitEquip",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.BA.BUSBenefitEquipList",  
	        QueryName:"GetBenefitEquip",
	        Data:lnk,
	        ReadOnly:getElementValue("ReadOnly"),
	       // Ejob:getElementValue("Job"),       // 台账添加job对多用户进行限制
	    },
	    });
	selectItems.splice(0,selectItems.length); 
	jQuery('#tDHCEQBenefitEquip').datagrid('unselectAll') 
	InfoStr="";  
}

function GetLnk()
{
	var lnk="";
	lnk=lnk+"^No="+getElementValue("No");
	lnk=lnk+"^Name="+getElementValue("Name");
	lnk=lnk+"^UseLocDR="+getElementValue("UseLocDR");
	lnk=lnk+"^MinValue="+getElementValue("MinValue");
	lnk=lnk+"^MaxValue="+getElementValue("MaxValue");
	lnk=lnk+"^EquipTypeDR="+getElementValue("EquipTypeDR");
	lnk=lnk+"^ProviderDR="+getElementValue("ProviderDR");
	lnk=lnk+"^Status="+getElementValue("Status");
	lnk=lnk+"^QXType="+getElementValue("QXType");
	//设备属性查询
	var SelectType=$("#EquipAttributeList").keywords("getSelected");
	var EquipAttributeString=""
	if ((SelectType)||(SelectType!=undefined))
	{
		var i=SelectType.length;
		var EquipAttributeString=""
		for (var j=0;j<i;j++)
		{
			if(EquipAttributeString=="")
			{
				EquipAttributeString=SelectType[j].id
			}else
			{
				EquipAttributeString=EquipAttributeString+getElementValue("SplitNumCode")+SelectType[j].id
			}
		}
	}
	lnk=lnk+"^EquipAttributeString="+EquipAttributeString
	return lnk
}
function isselectItem() {
        for (var i = 0; i < selectItems.length; i++) {
            jQuery('#tDHCEQBenefitEquip').datagrid('selectRecord', selectItems[i]); //根据id选中行 
        }
}

//判断选中记录的ID是否已存在checkedItems这个数组里
function findSelectItem(ID) {
        for (var i = 0; i < selectItems.length; i++) {
            if (selectItems[i] == ID) return i;
        }
        return -1;
}
//将选中记录的ID是存储checkedItems这个数组里
function addselectItem(rowIndex, rowData) {
        //var row = jQuery('#tDHCEQBenefitEquip').datagrid('getSelections');
	    var rowid=rowData.TRowID;
	    /// modefied by by zc 2017-06-25 ZC0031 begin
	    var res = tkMakeServerCall("web.DHCEQBatchDisuseRequest", "CheckEquipDR",'','',rowData.TRowID,'','','Y');
	    var ret=res.split("^");
	    if (ret[0]!="0")
		{
		    $.messager.popover({msg:ret[1],type:'alert'});
		    $('#tDHCEQBenefitEquip').datagrid('unselectRow', rowIndex);
		}
		/// modefied by by zc 2017-06-25 ZC0031 end
		if (ret[0]=="0")
		{
        	for (var i = 0; i < row.length; i++) {
            	if (findSelectItem(row[i].TRowID) == -1) {
                	selectItems.push(row[i].TRowID);
            	}
        	}
		}
}
//清楚所有选中记录的ID
function removeAllItem(rows) {
        for (var i = 0; i < rows.length; i++) {
            var k = findSelectItem(rows[i].TRowID);
            if (k != -1) {
                selectItems.splice(i, 1);
            }
        }
}
//清楚单条选中记录的ID
function removeSingleItem(rowIndex, rowData) {
        var k = findSelectItem(rowData.TRowID);
        if (k != -1) {
            selectItems.splice(k, 1);
        }
}
function BSelectAll_Click() //全选
{
	messageShow('popover','alert','提示',"当前页面未被选中的设备被其他业务单据占用")
	jQuery('#tDHCEQBenefitEquip').datagrid('selectAll');
}
function BUnSelectAll_Click() //取消全选
{
	selectItems.splice(0,selectItems.length);
	jQuery('#tDHCEQBenefitEquip').datagrid('unselectAll');
}

//Modify By zx 2020-02-20 BUG ZX0076
$("#ChooseCondition").popover({trigger:'manual',placement:'bottom',content:'<table><tr><td><input type="radio" name="condition" value="2"></td><td>等于</td></tr><tr><td><input type="radio" name="condition" value="1" checked></td><td>包含</td></tr><tr><td><input type="radio" name="condition" value="0"></td><td>不含</td></tr></table>'});
$("#ChooseCondition").click(function(){
	$("#ChooseCondition").popover('show');
	if(conditionFlag==0)
	{
		$('input[name="condition"]').click(function(){
	   		nameConditionLimit=$("input[name='condition']:checked").val();
	   		$("#ChooseCondition").popover('hide');
	   		$("#ChooseCondition").text($(this).parent().next().text());
		});
	}
	conditionFlag=1;
});

//从设备清单中保存效益设备
function BSave_Clicked()
{	
var checkedItems = $('#tDHCEQBenefitEquip').datagrid('getChecked');
	var selectItems = [];
	$.each(checkedItems, function(index, item){
        	selectItems.push(item.TRowID);
		});
	if(selectItems=="")
	{
		messageShow('popover','error','提示',"未选择设备！")
		return false;
	}
	var Listdatas=selectItems.toString()
  	var data=tkMakeServerCall("web.DHCEQ.BA.BUSBenefitEquipList","SaveEquipData",Listdatas);
	data=data.replace(/\ +/g,"")	//去掉空格
	data=data.replace(/[\r\n]/g,"")	//去掉回车换行
	data=data.split("^");
	var num=data[0];
	var errmesg=data[1];
	if (errmesg=="")
	{
			messageShow('popover','info','提示',"批量生成效益设备成功,生成"+num+"台效益设备")
			websys_showModal("options").mth();
			jQuery('#tDHCEQBenefitEquip').datagrid('reload');
	}
	else
	{
		if (num!="0")
		{
				messageShow('popover','info','提示',"批量效益设备生成"+num+"台,有编号为"+errmesg+"效益设备生成失败")
	            websys_showModal("options").mth();
	            jQuery('#tDHCEQBenefitEquip').datagrid('reload');

		}
		else
		{
			messageShow('popover','error','提示',"效益设备生成失败")
			return;
		}
	}

}