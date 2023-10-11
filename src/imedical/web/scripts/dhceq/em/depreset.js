var editFlag="undefined";
var SelectRowID="";
var EQRowID=getElementValue("EQRowID");
var EQUseLocDR=getElementValue("EQUseLocDR");
var CARowID=getElementValue("CARowID");
var CAEquipDR=getElementValue("CAEquipDR");
var CAAllotType=getElementValue("CAAllotType");
var CATypes=getElementValue("CATypes");
var CAHold2=getElementValue("CAHold2");
var ReadOnly=getElementValue("ReadOnly");
var CAHold1=parseFloat(getElementValue("CAHold1"));
var Columns=getCurColumnsInfo('EM.G.Depre.CostAllot','','','')
var ObjSources=new Array();
var HasDepre=tkMakeServerCall("web.DHCEQ.Plat.BUSMonthDepre","EQHasDepre",getElementValue("EQRowID"));

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});
		
function initDocument()
{
	initUserInfo();
    initMessage(); //获取所有业务消息
    initLookUp();
	defindTitleStyle(); 
    initButton();
    initButtonWidth();
    fillData();	//初始化设备信息
    initEditDepreInfo();
    setRequiredElements("EQDepreMethodDR_DMDesc",true);
	$HUI.datagrid("#tDHCEQCostAllot",{   
	    url:$URL, 
	    queryParams:{
		    	ClassName:"web.DHCEQ.Plat.BUSMonthDepre",
	        	QueryName:"CostAllot",
				CARowID:CARowID,
				Amount:CAHold1,
				LocID:EQUseLocDR,
				DepreFee:getElementValue("EQPreMonthDepre"),
				vCATypes:CATypes,
				vCAHold2:CAHold2,
				vCAAllotType:CAAllotType
			},
			border:false,
			rownumbers:true,
			singleSelect:true,
			fitColumns:true,
			toolbar:[{
				iconCls:'icon-add',
				text:'新增',
				id:'add',
				handler:function(){insertRow();}
			},
			{
                iconCls: 'icon-cancel',
				text:'删除',
				id:'delete',
				handler:function(){DeleteData();}
			}],
			columns:Columns,
		    onClickRow: function (rowIndex, rowData) {//双击选择行编辑
				if (editFlag!=rowIndex) 
				{
					if (endEditing())
					{
						$('#tDHCEQCostAllot').datagrid('selectRow', rowIndex).datagrid('beginEdit', rowIndex);
						editFlag = rowIndex;
						modifyBeforeRow = $.extend({},$('#tDHCEQCostAllot').datagrid('getRows')[editFlag]);
						bindGridEvent();  //编辑行监听响应
					} else {
						$('#tDHCEQCostAllot').datagrid('selectRow', editFlag);
					}
				}
				else
				{
					endEditing();
				}
		    
	        },
			onSelect:function(index,row){
				if (SelectRowID!=index)
				{
					SelectRowID=index
				}
				else
				{
					SelectRowID=""
				}
			},
			onLoadSuccess:function(){
				var rows = $('#tDHCEQCostAllot').datagrid('getRows');
			    for (var i = 0; i < rows.length; i++)
			    {
					ObjSources[i]=new SourceInfo(rows[i].CALAllotLocDR);
			    }
			}
	});
	var ReadOnly=getElementValue("ReadOnly")
	if ((ReadOnly==1)||(ReadOnly=="Y"))
	{
		$("#add").linkbutton("disable");
		$("#delete").linkbutton("disable");
		$("#BSave").linkbutton("disable");
	}
	$('input#EQDepreTotalFee').on('keyup',function(){
        ChangeDepreTotalFee_Changed();
    })
    $('input#EQNetFee').on('keyup',function(){
        ChangeNetFee_Changed();
    })
    $('input#EQDepreTotal').on('keyup',function(){
        ChangeDepreTotal_Changed();
    })
    $('input#EQRemainDepreMonth').on('keyup',function(){
        ChangeRemainDepreTotal_Changed();
    })
    $('input#EQLimitYearsNum').on('keyup',function(){
        ChangeLimitYearsNum_Changed();
    })
}

function fillData()
{
	var RowID=getElementValue("EQRowID");
	if (RowID=="") return;
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.BUSMonthDepre","GetOneEquip",RowID);
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {$.messager.alert(jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	showFundsTip(jsonData.Data);
	$("#EQDepreStatus").switchbox('setValue',JSON.parse(jsonData.Data.EQDepreStatus));
}

function endEditing()
{
	if (editFlag == undefined){return true}
	if ($('#tDHCEQCostAllot').datagrid('validateRow', editFlag)){
		$('#tDHCEQCostAllot').datagrid('endEdit', editFlag);
		editFlag = undefined;
		return true;
	} else {
		return false;
	}
}

function initCAAllotType()
{
	var data=[{
				id: '0',
				text: '固定比例(%)'
			}]
	if (CATypes==2)	data=[{id: '0',text: '固定比例(%)'},{	id: '6',text: '固定值'}] 
	var CAAllotType = $HUI.combobox('#CAAllotType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:data
	});
	
}
function bindGridEvent()
{
	if (editFlag == undefined){return true}
    try
    {
        var objGrid = $("#tDHCEQCostAllot");
        var invRateEdt = objGrid.datagrid('getEditor', {index:editFlag,field:'CALAllotPercentNum'});
        var invValueEdt = objGrid.datagrid('getEditor', {index:editFlag,field:'CALWorkLoadNum'});
        var EQPreMonthDepre=parseFloat(getElementValue("EQPreMonthDepre"));
		var rowData = $('#tDHCEQCostAllot').datagrid('getSelected');
        
        // 数量  绑定 离开事件
        $(invRateEdt.target).bind("blur",function(){
            var CALAllotPercentNum=parseFloat($(invRateEdt.target).val());
	        var CALWorkLoadNum=CAHold1*(CALAllotPercentNum/100)
			CALWorkLoadNum=CALWorkLoadNum.toFixed(2)
	        
	        //更新分摊值
			var objGrid = $("#tDHCEQCostAllot"); 
			var CALWorkLoadNumEditor = objGrid.datagrid('getEditor', {index:editFlag,field:'CALWorkLoadNum'});
			$(CALWorkLoadNumEditor.target).val(CALWorkLoadNum);
			
			//更新分摊月折旧
			var CALDepreFee=EQPreMonthDepre*(CALAllotPercentNum/100);
			rowData.CALDepreFee=CALDepreFee.toFixed(2);
			
			$('#tDHCEQCostAllot').datagrid('endEdit',editFlag);
			//$('#tDHCEQCostAllot').datagrid('beginEdit',editFlag);
        });
        $(invValueEdt.target).bind("blur",function(){
            var CALWorkLoadNum=parseFloat($(invValueEdt.target).val());
	        //var rowData = $('#tDHCEQCostAllot').datagrid('getSelected');
	        var CALAllotPercentNum=CALWorkLoadNum*100/CAHold1;
			CALAllotPercentNum=CALAllotPercentNum.toFixed(2)
			
			//更新分摊比例
			var objGrid = $("#tDHCEQCostAllot"); 
			var CALAllotPercentNumEditor = objGrid.datagrid('getEditor', {index:editFlag,field:'CALAllotPercentNum'});
			$(CALAllotPercentNumEditor.target).val(CALAllotPercentNum);
			
			//更新分摊月折旧
			var CALDepreFee=EQPreMonthDepre*(CALAllotPercentNum/100);
			rowData.CALDepreFee=CALDepreFee.toFixed(2);
			
			$('#tDHCEQCostAllot').datagrid('endEdit',editFlag);
			//$('#tDHCEQCostAllot').datagrid('beginEdit',editFlag);
        });
    }
    catch(e)
    {
        alertShow(e);
    }
}
// 插入新行
function insertRow()
{
	if(editFlag>="0"){
		$("#tDHCEQCostAllot").datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
	}
    var rows = $("#tDHCEQCostAllot").datagrid('getRows');
    var lastIndex=rows.length-1
    if (lastIndex==-1) lastIndex=0
    var newIndex=rows.length
	$("#tDHCEQCostAllot").datagrid('insertRow', {index:newIndex,row:{}});
	editFlag=0;
}

function DeleteData()
{
	var graidLength=$('#tDHCEQCostAllot').datagrid('getRows').length;
	if(graidLength<2)
	{
		messageShow("alert",'info',"提示","当前行不可删除!");
		return;
	}
	if (editFlag != undefined)
	{
		jQuery("#tDHCEQCostAllot").datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
		$('#tDHCEQCostAllot').datagrid('deleteRow',editFlag);
	} 
	else
	{
		messageShow("alert",'info',"提示","请选中一行!");
	}
}

function BSave_Clicked()
{
	if(editFlag>="0"){
		jQuery("#tDHCEQCostAllot").datagrid('endEdit', editFlag);//结束编辑，传入之前编辑的行
	}
	
	var dataList=""
	var rows = $('#tDHCEQCostAllot').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		if (oneRow.CALAllotLocDR=="")
		{
			alertShow("第"+(i+1)+"行科室ID不能为空!")
			return "-1"
		}
		if ((oneRow.CALAllotPercentNum=="")&&(CAAllotType!="6"))
		{
			alertShow("第"+(i+1)+"行分摊百分比不能为空!")
			return "-1"
		}
		if (oneRow.CALWorkLoadNum=="")
		{
			alertShow("第"+(i+1)+"行分摊额度不能为空!")
			return "-1"
		}
		
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+getElementValue("SplitRowCode")+RowData;
		}
	}
	if (dataList=="")
	{
		alertShow("分摊明细不能为空!");
		return;
	}
	
	if((CAAllotType=="")||(CATypes=="")||(CAHold2==""))
	{
		alertShow("设备分摊设置有空值!");
		return;
	}
	
	if((CAAllotType=="")||(CATypes=="")||(CAHold2==""))
	{
		alertShow("设备分摊设置有空值!");
		return;
	}
	
	if((getElementValue("EQDepreMethodDR")==""))
	{
		alertShow("折旧方法不能为空!");
		return;
	}
	
	//保存设备信息
	var EquipInfo={};
	EquipInfo.EQRowID=EQRowID;
	EquipInfo.EQDepreMethodDR=getElementValue("EQDepreMethodDR");
	EquipInfo.EQLimitYearsNum=getElementValue("EQLimitYearsNum");
	EquipInfo.EQStartDepreDate=getElementValue("EQStartDepreDate");
	EquipInfo.EQDepreStatus=$("#EQDepreStatus").switchbox('getValue');
	if (HasDepre!=1){
		var EQOriginalFee=Number(getElementValue("EQOriginalFee"));
		var EQDepreTotalFee=Number(getElementValue("EQDepreTotalFee"));
		var EQNetFee=Number(getElementValue("EQNetFee"));
		var EQLimitYearsNum=Number(getElementValue("EQLimitYearsNum"));
		var EQDepreTotal=getElementValue("EQDepreTotal");
		var EQRemainDepreMonth=getElementValue("EQRemainDepreMonth");
		if (parseFloat(EQDepreTotalFee.toFixed(2))<0){
			alertShow("累计折旧不能小于0!");
			return;
		}
		if (parseFloat(EQNetFee.toFixed(2))<0){
			alertShow("净值不能小于0!");
			return;
		}
		if (parseInt(EQDepreTotal)<0){
			alertShow("已折期数不能小于0!");
			return;
		}
		if (parseInt(EQRemainDepreMonth)<0){
			alertShow("剩余期数不能小于0!");
			return;
		}
		if (((NumFormat(EQDepreTotalFee.toFixed(2))*100+NumFormat(EQNetFee.toFixed(2))*100)/100).toFixed(2)!=NumFormat(EQOriginalFee.toFixed(2))){
			alertShow("累计折旧与净值之和不等于原值，请修正!");
			return;
		}
		if (Number(EQLimitYearsNum*12)!=(Number(EQDepreTotal)+Number(EQRemainDepreMonth))){
			alertShow("已折期数与剩余期数之和不等于折旧年限*12，请修正!");
			return;
		}
		if (parseInt(+EQDepreTotal)!=parseFloat(+EQDepreTotal)){
			alertShow("已折期数需为整数!");
			return;
		}else{
			var EQDepreTotal=parseInt(+EQDepreTotal);
		}
		if (parseInt(EQRemainDepreMonth)!=parseFloat(EQRemainDepreMonth)){
			alertShow("剩余期数需为整数!");
			return;
		}else{
			var EQRemainDepreMonth=parseInt(+EQRemainDepreMonth);
		}
		//已修改设备不允许调整
		//累计折旧不相等，记录改后原值
		if (Number(getElementValue("DepreTotalFee"))!=Number(EQDepreTotalFee)){
			EquipInfo.EQDepreTotalFee=EQDepreTotalFee;
			EquipInfo.EQNetFee=EQNetFee;
			EquipInfo.EQDepreTotal=EQDepreTotal;
			EquipInfo.EQRemainDepreMonth=EQRemainDepreMonth;
		}
		//折旧期数不相等，记录调后已折期数
		if (Number(getElementValue("DepreTotal"))!=Number(EQDepreTotal)){
			EquipInfo.EQDepreTotalFee=EQDepreTotalFee;
			EquipInfo.EQNetFee=EQNetFee;
			EquipInfo.EQDepreTotal=EQDepreTotal;
			EquipInfo.EQRemainDepreMonth=EQRemainDepreMonth;
		}
	}
	EquipInfo=JSON.stringify(EquipInfo);
	var jsonData=tkMakeServerCall("web.DHCEQ.Plat.BUSMonthDepre","SaveEquipData",EquipInfo,"",curUserID,curLocID);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE!=0)
    {
		alertShow("保存设备折旧信息失败!详细:"+jsonData.Data);
		return
    }
	//保存折旧设置信息
	var CostAllot={};
	CostAllot.CARowID=CARowID;
	CostAllot.CAEquipDR=CAEquipDR;
	CostAllot.CAAllotType=CAAllotType;
	CostAllot.CATypes=CATypes;
	CostAllot.CAHold1=CAHold1;
	CostAllot.CAHold2=CAHold2;
	CostAllot=JSON.stringify(CostAllot);
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSCostAllot","SaveData",CostAllot,dataList,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var val="&EQRowID="+EQRowID+"&ReadOnly="+ReadOnly;
		url="dhceq.em.depreset.csp?"+val
	    window.location.href= url;
	}
	else
    {
		alertShow("错误信息:"+jsonData.Data);
		return
    }
}

function setSelectValue(elementID,rowData)
{
	setElement(elementID.split("_")[0],rowData.TRowID);
}

function clearData(vElementID)
{
	var _index = vElementID.indexOf('_')
	if(_index != -1){
		var vElementDR = vElementID.slice(0,_index)
		if($("#"+vElementDR).length>0)
		{
			setElement(vElementDR,"");
		}
	}
}

function GetUseLoc(index,data)
{
	var Length=ObjSources.length
	for (var i=0;i<Length;i++)
	{
		if ((ObjSources[i].SourceID==data.TRowID)&&(editFlag!=i))
		{
			var RowNo=i+1
			alertShow("选择的科室与第"+RowNo+"行重复!")
			return;
		}
	}
	
	var rowData = $('#tDHCEQCostAllot').datagrid('getSelected');
	rowData.CALAllotLocDR=data.TRowID;
	ObjSources[index]=new SourceInfo(rowData.CALAllotLocDR);
	var editor = $('#tDHCEQCostAllot').datagrid('getEditor',{index:editFlag,field:'CALAllotLoc'});
	$(editor.target).combogrid("setValue",data.TName);
	$('#tDHCEQCostAllot').datagrid('endEdit',editFlag);
}

function SourceInfo(SourceID)
{
	this.SourceID=SourceID;
}

function BClosed_Clicked() 
{
	var openerType=typeof(window.opener)
	if (openerType!="undefined")
	{
		window.close();
	}
	closeWindow('modal');
	//websys_showModal("close");
}

function showFundsTip(data)
{
	var RowID=$("#EQRowID").val();
	//异步处理
	var jsonData = $.cm({
		ClassName:"web.DHCEQ.EM.BUSFunds",
		QueryName:"GetFunds",
		FromType:"1",
		FromID:RowID,
		FundsAmount:data["EQOriginalFee"]
	},false);
	$HUI.tooltip('#EQFunds',{
		position: 'bottom',
		content: function(){
			var content='<div style="padding:5px;font-size:16px;color:#ffffff"><ul>';
			for (var i=0;i<jsonData.rows.length;i++)
			{
				var TFundsTypeDR=jsonData.rows[i].TFundsTypeDR;
				var TFundsType=jsonData.rows[i].TFundsType;
				var TFee=jsonData.rows[i].TFee;
				var TFinaceItem=jsonData.rows[i].TFinaceItem;
				var TCurDepreTotalFee=jsonData.rows[i].TCurDepreTotalFee; 
				if (TFundsTypeDR==data["EQSelfFundsFlag"]) continue;
				content=content+'<li>'+TFundsType+'：'+TFee+' '+'累计折旧:'+TCurDepreTotalFee+'</li>'; 
			}
			content=content+'</ul></div>';
			return content;
		},
		onShow: function(){
			$(this).tooltip('tip').css({
				backgroundColor: '#88a8c9',
				borderColor: '#4f75aa',
				boxShadow: '1px 1px 3px #4f75aa'
			});
		 },
		onPosition: function(){
			$(this).tooltip('tip').css('bottom', $(this).offset().bottom);
			$(this).tooltip('arrow').css('bottom', 20);
		}
	});
}

//判断设备是否存在折旧，无折旧设备折旧信息可编辑
function initEditDepreInfo()
{
	var RowID=getElementValue("EQRowID");
	if (RowID=="") return;
	if (HasDepre==1){
		disableElement("EQDepreTotalFee",true);
		disableElement("EQNetFee",true);
		disableElement("EQDepreTotal",true);
		disableElement("EQRemainDepreMonth",true);
	}else{
		disableElement("EQDepreTotalFee",false);
		disableElement("EQNetFee",false);
		disableElement("EQDepreTotal",false);
		disableElement("EQRemainDepreMonth",false);
	}
}

function NumFormat(Num)
{
	if (Num=="") return 0;
	else{ return parseFloat(Num);}
}

//变动累计折旧
function ChangeDepreTotalFee_Changed()
{
	var EQOriginalFee=getElementValue("EQOriginalFee");
	var RemainFeeRate=getElementValue("RemainFeeRate");
	var EQDepreTotalFee=Number(getElementValue("EQDepreTotalFee"));
	var tmpChangedNetFeeValue=Number(EQOriginalFee)-EQDepreTotalFee;
    if (RemainFeeRate>0)
    {
        var CAChangedNetRemainFee=(EQOriginalFee*RemainFeeRate/100).toFixed(2)
        if (tmpChangedNetFeeValue<CAChangedNetRemainFee)
        {
            alertShow("净值不能小于净残值:"+CAChangedNetRemainFee);
            return
        }
    }
    setElement("EQNetFee",tmpChangedNetFeeValue.toFixed(2));
}

//变动净值
function ChangeNetFee_Changed()
{
	var EQOriginalFee=getElementValue("EQOriginalFee");
	var RemainFeeRate=getElementValue("RemainFeeRate");
	var EQNetFee=Number(getElementValue("EQNetFee"));
	var tmpChangedTotalFeeValue=Number(EQOriginalFee)-EQNetFee;
    if (RemainFeeRate>0)
    {
        var CAChangedNetRemainFee=(EQOriginalFee*RemainFeeRate/100).toFixed(2)
        if (EQNetFee<CAChangedNetRemainFee)
        {
            alertShow("净值不能小于净残值:"+CAChangedNetRemainFee);
            return
        }
    }
    setElement("EQDepreTotalFee",tmpChangedTotalFeeValue.toFixed(2));
}

function ChangeDepreTotal_Changed()
{
	var EQLimitYearsNum=getElementValue("EQLimitYearsNum");
	var EQDepreTotal=Number(getElementValue("EQDepreTotal"));
	var tmpRemainDepreTotal=EQLimitYearsNum*12-EQDepreTotal;
    setElement("EQRemainDepreMonth",tmpRemainDepreTotal);
}

function ChangeRemainDepreTotal_Changed()
{
	var EQLimitYearsNum=getElementValue("EQLimitYearsNum");
	var EQRemainDepreMonth=Number(getElementValue("EQRemainDepreMonth"));
	var tmpDepreTotal=EQLimitYearsNum*12-EQRemainDepreMonth;
    setElement("EQDepreTotal",tmpDepreTotal);
}

function ChangeLimitYearsNum_Changed()
{
	var EQLimitYearsNum=getElementValue("EQLimitYearsNum");
	var EQDepreTotal=Number(getElementValue("EQDepreTotal"));
	var tmpRemainDepreTotal=EQLimitYearsNum*12-EQDepreTotal;
    setElement("EQRemainDepreMonth",tmpRemainDepreTotal);
}