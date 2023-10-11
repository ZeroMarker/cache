jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
	
);
function initDocument()
{
	initPanel();
}
function initPanel()
{
	initTopPanel();		
}
//初始化查询头面板
function initTopPanel()
{
	initUserInfo()  ////Modiedy by zc0057 初始化会话变量
	showBtnIcon('BEvaluate^BPreEvaluate^BReEvaluate',false); //modified by LMH 20230202 动态设置是否极简显示按钮图标
	initButtonWidth();
	jQuery('#BEvaluate').bind('click', BEvaluate_Clicked)
	jQuery('#BReEvaluate').bind('click', BReEvaluate_Clicked)
	jQuery('#BPreEvaluate').bind('click', BPreEvaluate_Clicked)
	defindTitleStyle();
	initDHCEQRiskEvaluate();			//初始化表格
	FillData();
	SetEnabled();
}	
function BFind_Clicked()
{
	initDHCEQRiskEvaluate()
}
function initDHCEQRiskEvaluate()
{
	$HUI.datagrid("#tDHCEQRiskEvaluate",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.Risk.BUSEvaluate",
	        QueryName:"GetRiskEvaluate",
	        SourceType:getElementValue("SourceType"),
	        SourceID:getElementValue("SourceID"),
			RowID:getElementValue("RowID"),
	    },
	    singleSelect:true,
		//fitColumns:true,  //modified by LMH 20230203  列少时默认向左对齐
    	onClickRow: onClickRow,//点击单元格触发事件
		columns:[[
			{field:'TRiskEvaluationListDR',title:'TRiskEvaluationListDR',width:50,align:'center',hidden:true},
			{field:'TRiskEvaluationDR',title:'TRiskEvaluationDR',width:50,align:'center',hidden:true},
			{field:'TRiskItemDR',title:'TRiskItemDR',width:50,align:'center',hidden:true},
			{field:'TRiskItem',title:'',width:200,align:'center'},
			{field:'TRiskItemValueDR',title:'TRiskItemValueDR',width:50,align:'center',hidden:true},
			{field:'TRiskItemValue',title:'风险种类',width:200,align:'center'},
			{field:'TWeights',title:'权重',width:100,align:'center'},
			{field:'TOpt',title:'选择',width:100,align:'center',formatter: RadioOperation},
		]],
		onLoadSuccess: function (data) {                      //data是默认的表格加载数据，包括rows和Total
  		if (data.rows.length > 0) {
     		//调用mergeCellsByField()合并单元格
     		mergeCellsByField("tDHCEQRiskEvaluate", "TRiskItem");
  }
}


});
}
function FillData()
{
	var rowid=jQuery('#RowID').val()
	if (rowid=="") return ;
	jQuery.ajax({
		url:'dhceq.jquery.method.csp',
		Type:'POST',
		data:{
			ClassName:'web.DHCEQ.Risk.BUSEvaluate',
			MethodName:'GetOneRiskEvaluate',
			Arg1:rowid,
			ArgCnt:1
		},
		success:function(data,response,status)
		{
			data=data.replace(/\ +/g,"")	//去掉空格
			data=data.replace(/[\r\n]/g,"")	//去掉回车换行
			var list=data.split("^");
			jQuery('#RiskGradeDR').val(list[4]);
			jQuery('#Remark').val(list[8]);
			jQuery('#Result').val(list[14]);
			jQuery('#Score').val(list[3]);
		}
	});
}	
function RadioOperation(value,row,index){
		if(value=="Y"){
			return '<input type="radio" name="radio'+row.TRiskItemDR+'" checked="checked" value="'+row.TRiskItemValueDR+'">';
		}
		else{
		return '<input type="radio" name="radio'+row.TRiskItemDR+'" value="'+row.TRiskItemValueDR+'">';
		}

}
function SetEnabled()
{
	var ReadOnly=jQuery('#ReadOnly').val();
	var RowID=jQuery('#RowID').val();
	if (RowID=="")
	{
        jQuery('#BReEvaluate').hide();
        jQuery('#BReEvaluate').attr('disabled',"true")
        jQuery('#BPreEvaluate').hide();
        jQuery('#BPreEvaluate').attr('disabled',"true")
	}
	else
	{

		jQuery('#BEvaluate').hide();
		jQuery('#BEvaluate').attr('disabled',"true")
		if(ReadOnly!=0)
		{
			jQuery('#BReEvaluate').hide();
        	jQuery('#BReEvaluate').attr('disabled',"true")
        	jQuery('#BPreEvaluate').hide();
        	jQuery('#BPreEvaluate').attr('disabled',"true")
		}
	}
	
}
function BEvaluate_Clicked()
{
	var val=CombineData();	
    var valList=GetTableInfo();
    if (valList=="-1")  return;
    var Rtn=tkMakeServerCall("web.DHCEQ.Risk.BUSEvaluate", "SaveRiskEvaluate",val,valList);
    var list=Rtn.split("^");
	if(list[0]=="0") 
	{
		jQuery.messager.show({title: '提示',msg: '保存成功'});
		var url="dhceq.em.riskevaluate.csp?&ReadOnly=0&RowID="+list[1]+"&SourceType="+jQuery('#SourceType').val()+"&SourceID="+jQuery('#SourceID').val()+"&Name="+jQuery('#Name').val();
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href=url;
	} 
	else
	{
		$.messager.alert('保存失败！','错误代码:'+list[0], 'warning');
	}
    
}
function BReEvaluate_Clicked()
{
	var val=CombineData();	
    var valList=GetTableInfo();
    if (valList=="-1")  return;
    var Rtn=tkMakeServerCall("web.DHCEQ.Risk.BUSEvaluate", "SaveRiskEvaluate",val,valList);
    var list=Rtn.split("^");
	if(list[0]=="0") 
	{
		jQuery.messager.show({title: '提示',msg: '保存成功'});
		"dhceq.em.riskevaluate.csp?&ReadOnly=0&RowID="+list[1]+"&SourceType="+jQuery('#SourceType').val()+"&SourceID="+jQuery('#SourceID').val()+"&Name="+jQuery('#Name').val();
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href=url;
	} 
	else
	{
		$.messager.alert('保存失败！','错误代码:'+list[0], 'warning');
	}
}
function BPreEvaluate_Clicked()
{
	var Rtn=tkMakeServerCall("web.DHCEQ.Risk.BUSEvaluate", "SumRiskEvaluate",jQuery('#SourceType').val(),jQuery('#SourceID').val());
	if(Rtn<2)
	{
		jQuery.messager.show({title: '提示',msg: '只评估了一次'});
		return ;
	}
	var str="dhceq.em.riskevaluatehistory.csp?&RowID="+jQuery('#RowID').val()+"&SourceType="+jQuery('#SourceType').val()+"&SourceID="+jQuery('#SourceID').val()+"&Name="+jQuery('#Name').val()
	showWindow(str,"历史评估明细","","","","","","","middle"); //modify by lmm 2020-06-05 UI
}
function GetTableInfo()
{
	var j=0;
	var vNum=tkMakeServerCall("web.DHCEQ.Risk.BUSEvaluate", "SumRiskItem");
	if(vNum<1)
	{
		jQuery.messager.show({title: '提示',msg: '没有风险评估项目,无法评估'});
		return -1;
	}
	var info=""
	jQuery('#tDHCEQRiskEvaluate').datagrid('getPanel').find(':radio:checked').each(function(i,val){
		if(info=="") 
		{
			info=val.value
		}
		else
		{
			info=info+"&"+val.value
		}
		j=i
	})
	if(j<vNum-1)  ////Modiedy by zc0057 修改计数不对问题
	{
		jQuery.messager.show({title: '提示',msg: '风险评估项目没有全部完成'});
		return -1;
	}
	return info;
}
function onClickRow()
{
	var list=""
	jQuery('#tDHCEQRiskEvaluate').datagrid('getPanel').find(':radio:checked').each(function(i,val){
		if(list=="") 
		{
			list=val.value
		}
		else
		{
			list=list+","+val.value
		}	
	})
	var res = tkMakeServerCall("web.DHCEQ.Risk.BUSEvaluate", "GetRiskGradeAndScore",list);
	var ret=res.split("^"); 
	if(jQuery('#ReadOnly').val()==0)
	{
		jQuery('#RiskGradeDR').val(ret[0]);
		jQuery('#Result').val(ret[1]);
		jQuery('#Score').val(ret[2]);
	}
}
function CombineData()
{
	var val="";
	val=jQuery('#RowID').val();
	val+="^^"+jQuery('#SourceType').val();
	val+="^"+jQuery('#SourceID').val();
	val+="^"+jQuery('#Score').val();
	val+="^"+jQuery('#RiskGradeDR').val();
	val+="^"+curUserID;   ////Modiedy by zc0057 添加操作人  
	val+="^^^"+jQuery('#Remark').val();
	return val;
}

function mergeCellsByField(tableID, colList) {
    var ColArray = colList.split(",");
    var tTable = $("#" + tableID);
    var TableRowCnts = tTable.datagrid("getRows").length;
    var tmpA;
    var tmpB;
    var PerTxt = "";
    var CurTxt = "";
    var alertStr = "";
    for (j = ColArray.length - 1; j >= 0; j--) {
        PerTxt = "";
        tmpA = 1;
        tmpB = 0;

        for (i = 0; i <= TableRowCnts; i++) {
            if (i == TableRowCnts) {
                CurTxt = "";
            }
            else {
                CurTxt = tTable.datagrid("getRows")[i][ColArray[j]];
            }
            if (PerTxt == CurTxt) {
                tmpA += 1;
            }
            else {
                tmpB += tmpA;
                
                tTable.datagrid("mergeCells", {
                    index: i - tmpA,
                    field: ColArray[j],
                    rowspan: tmpA,
                    colspan: null,
                });
                tTable.datagrid("mergeCells", { 
                    index: i - tmpA,
                    field: "Ideparture",
                    rowspan: tmpA,
                    colspan: null
                });
               
                tmpA = 1;
            }
            PerTxt = CurTxt;
        }
    }
}
