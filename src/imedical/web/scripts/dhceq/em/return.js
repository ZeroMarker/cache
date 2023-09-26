var editIndex=undefined;
var modifyBeforeRow = {};
var toolbarFlag=0;
var RRowID=getElementValue("RRowID");
if(getElementValue("ROutTypeDR")=="1")
{
	var Columns=getCurColumnsInfo('EM.G.Return.ReturnList','','','')
}
else
{
	var Columns=getCurColumnsInfo('EM.G.OutStock.OutStockList','','','')
}
var oneFillData={}
var ObjSources=new Array();

$(function(){
	initDocument()
	$(function(){$("#Loading").fadeOut("fast");});  // add by wy 2020-04-9 界面加载效果影藏 bug WY0060
	//setTimeout(initDocument,0);	//modified by csj 201901010 无效
});

function initDocument()
{
	initUserInfo();
	//add by wy 2020-4-29 1290934 恢复界面默认并修复bug
	setElement("RReturnLocDR",curLocID)	
    setElement("RReturnLocDR_CTLOCDesc",curLocName)	
	setElement("REquipTypeDR_ETDesc",getElementValue("REquipType"));	//初始化默认值
	setElement("REquipTypeDR",getElementValue("REquipTypeDR"));
    initMessage(); //获取所有业务消息
    //initLookUp("MRObjLocDR_LocDesc^MRExObjDR_ExObj^"); //初始化放大镜
    initLookUp(); //初始化放大镜
	muilt_Tab()  //add by lmm 2020-06-29 回车下一输入框
	//if(getElementValue("RReturnLoc"))	setElement("RReturnLocDR_CTLOCDesc",getElementValue("RReturnLoc"))	 Mozy0239	1130032	2019-12-17	取消赋值
    //if(getElementValue("REquipType"))	setElement("REquipTypeDR_ETDesc",getElementValue("REquipType"))	 Mozy0239	1130032	2019-12-17	取消赋值
    //begin add by jyp 20190307
    
	var paramsFrom=[{"name":"Type","type":"2","value":"2"},{"name":"LocDesc","type":"1","value":"RReturnLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0101"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("RReturnLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
	
	var paramsFrom=[{"name":"Type","type":"2","value":""},{"name":"LocDesc","type":"1","value":"RUseLocDR_CTLOCDesc"},{"name":"vgroupid","type":"2","value":""},{"name":"LocType","type":"2","value":"0102"},{"name":"notUseFlag","type":"2","value":""}];
    singlelookup("RUseLocDR_CTLOCDesc","PLAT.L.Loc",paramsFrom,"");
    
	//end begin add by jyp 20190307
	defindTitleStyle(); 
    initButton(); //按钮初始化
    //initPage(); //非通用按钮初始化
    initButtonWidth();
    
    setRequiredElements("RReturnDate^RReturnLocDR_CTLOCDesc^REquipTypeDR_ETDesc^RProviderDR_VDesc^ROutTypeDR_OTDesc")
    fillData(); //数据填充
   	setEnabled(); //按钮控制
    //setElementEnabled(); //输入框只读控制 
    //initEditFields(); //获取可编辑字段信息
    initApproveButton(); //初始化审批按钮
	$HUI.datagrid("#DHCEQReturn",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.EM.BUSReturn",
	        	QueryName:"ReturnListNew",
				RowID:RRowID
		},
	    toolbar:[{
    			iconCls: 'icon-add',
                text:'新增',  
				id:'add',        
                handler: function(){
                     insertRow();
                }},     //modify by lmm 2020-04-03
                {
                iconCls: 'icon-save',
                text:'删除',
				id:'delete',
                handler: function(){
                     deleteRow();
                }}
                ],
		//rownumbers: true,  //如果为true，则显示一个行号列。
		singleSelect:true,
		fit:true,
		striped : true,
	    cache: false,
		//fitColumns:true,
		columns:Columns,
		//onClickRow:function(rowIndex,rowData){onClickRow();},
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onLoadSuccess:function(){
			creatToolbar();	
		}
	});
};
//合计行显示
function creatToolbar()
{
	var lable_innerText='总数量:'+totalSum("DHCEQReturn","RLReturnQtyNum")+'&nbsp;&nbsp;&nbsp;总金额:'+totalSum("DHCEQReturn","RLTotalFee").toFixed(2)
	$("#sumTotal").html(lable_innerText);
	var panel = $("#DHCEQReturn").datagrid("getPanel");
	var rows = $("#DHCEQReturn").datagrid('getRows');
    for (var i = 0; i < rows.length; i++) {
	    if ((rows[i].REquipDR=="")&&(rows[i].RInStockListDR==""))
	    {
		    $("#TEquipList"+"z"+i).hide();
		}
    }
    
	var Status=getElementValue("RStatus");
	if (Status>0)
	{
		//modify by lmm 2020-04-10 1266924
		disableElement("add",true);
		disableElement("delete",true);
	}
	var  job=$('#DHCEQReturn').datagrid('getData').rows[0].RLJob;
	setElement("RJob",job);
}
//填充数据
function fillData()
{
	//start by csj 20190125 台账链接到退货界面处理
	var EquipDR=getElementValue("EquipDR");
	if (EquipDR!="")
	{
		$cm({
			ClassName:"web.DHCEQ.EM.BUSEquip",
			MethodName:"GetOneEquip",
			RowID:EquipDR
		},function(jsonData){
			if (jsonData.SQLCODE<0) {$.messager.alert(jsonData.Data);return;}
			setElement("REquipTypeDR",jsonData.Data["EQEquipTypeDR"]); //设置类组ID
			setElement("REquipTypeDR_ETDesc",jsonData.Data["EQEquipTypeDR_ETDesc"]);//设置类组
			setElement("RProviderDR",jsonData.Data["EQProviderDR"]); //设置供应商ID
			setElement("RProviderDR_VDesc",jsonData.Data["EQProviderDR_VName"]); //设置供应商
			//modified by csj 20190202 可编辑列表暂时先这样处理
			var rows = $("#DHCEQReturn").datagrid('getRows');
			rows[0].RLEquip=jsonData.Data["EQName"];	//填充可编辑列设备名称，用户自行下拉选择退货设备
			$('#DHCEQReturn').datagrid('updateRow',{
				index: 0,
				row: rows[0],
			});
		});
	}
	//end by csj 20190125 台账链接到退货界面处理
	if (RRowID=="") return;
	var Action=getElementValue("Action");
	var Step=getElementValue("RoleStep");
	var ApproveRoleDR=getElementValue("ApproveRoleDR");
	
	jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSReturn","GetOneReturn",RRowID,ApproveRoleDR,Action,Step)
	jsonData=jQuery.parseJSON(jsonData);
	if (jsonData.SQLCODE<0) {messageShow("alert","error","错误提示","数据填充失败，错误代码"+jsonData.Data);return;}
	setElementByJson(jsonData.Data);
	oneFillData=jsonData.Data
    if (jsonData.Data["MultipleRoleFlag"]=="1")
    {
	    setElement("NextRoleDR",getElementValue("CurRole"));
	    setElement("NextFlowStep",getElementValue("RoleStep"));
	}
}
//按钮可用控制
function setEnabled()
{
	var Status=getElementValue("RStatus");
	var WaitAD=getElementValue("WaitAD");
	if (Status!="0")
	{
		disableElement("BDelete",true)
		disableElement("BSubmit",true)
		disableElement("BDeleteList",true);//270385 Add By BRB 2016-10-19
		if (Status!="")
		{
			disableElement("BSave",true)
		}
	}
	//审核后才可打印及生成转移单
	if (Status!="2")
	{
		disableElement("BPrint",true)
	}
	//非建单据菜单,不可更新等操作单据
	if (WaitAD!="off")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
	}
	///作废按钮
}
//选择框选择事件
function setSelectValue(elementID,rowData)
{
	if(elementID=="REquipTypeDR_ETDesc") {setElement("REquipTypeDR",rowData.TRowID)}
	else if(elementID=="RReturnLocDR_CTLOCDesc") {setElement("RReturnLocDR",rowData.TRowID);setElement("FromLocDR",rowData.TRowID);}	// Mozy0239	1130633	2019-12-17
	else if(elementID=="RProviderDR_VDesc") {setElement("RProviderDR",rowData.TRowID)}
	else if(elementID=="ROutTypeDR_OTDesc") {setElement("ROutTypeDR",rowData.TRowID)}
	else if(elementID=="RUseLocDR_CTLOCDesc") {setElement("RUseLocDR",rowData.TRowID)}
}

//hisui.common.js错误纠正需要
function clearData(str)
{
	setElement(str.split("_")[0],"")	//modified by csj 20190828
} 
// 插入新行
function insertRow()
{
	if(editIndex>="0"){
		jQuery("#DHCEQReturn").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
	}
    var rows = $("#DHCEQReturn").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    var RLInStockListDR=(typeof rows[lastIndex].RLInStockListDR=='undefined')?"":rows[lastIndex].RLInStockListDR
    var RLEquipDR=(typeof rows[lastIndex].RLEquipDR=='undefined')?"":rows[lastIndex].RLEquipDR
    if ((RLEquipDR=="")&&(RLInStockListDR==""))
    {
	    messageShow("alert","error","错误提示","第"+newIndex+"行数据为空!请先填写数据.");
	}
	else
	{
		jQuery("#DHCEQReturn").datagrid('insertRow', {index:newIndex,row:{}});
		editIndex=0;
		//隐藏新行的图标
		$("#Affix"+"z"+newIndex).hide()
		$("#FundsInfo"+"z"+newIndex).hide()
	}
}
//删除行
function deleteRow()
{
	var rows = $('#DHCEQReturn').datagrid('getRows');
	if (rows.length<2)
	{
		messageShow("alert",'info',"提示","唯一一行无法删除，请修改!");
		return;
	}
	if (editIndex>="0")
	{
		jQuery("#DHCEQReturn").datagrid('endEdit', editIndex);//结束编辑，传入之前编辑的行
		$('#DHCEQReturn').datagrid('deleteRow',editIndex)
	}
	else
	{
		messageShow("alert",'info',"提示","请选中一行!");
	}
}
//保存按钮操作
function BSave_Clicked()
{
	if (editIndex != undefined){ $('#DHCEQReturn').datagrid('endEdit', editIndex);}		//add by czf 2020-05-07 1304193
	if (getElementValue("ROutTypeDR")=="1")
	{
		if (getElementValue("RProviderDR")=="")
		{
			messageShow("alert","error","错误提示","供应商不能为空!");
			return
		}
	}
	else
	{
		if (getElementValue("ROutTypeDR")=="")
		{
			messageShow("alert","error","错误提示","减少类型不能为空!");
			return
		}
	}
	if (getElementValue("RReturnLocDR")=="")
	{
		messageShow("alert","error","错误提示","库房不能为空!");
		return
	}
	if (getElementValue("RReturnDate")=="")
	{
		messageShow("alert","error","错误提示","制单日期不能为空!");
		return
	}
	if (getElementValue("REquipTypeDR")=="")
	{
		messageShow("alert","error","错误提示","管理类组不能为空!");
		return
	}
	
	var data=getInputList();
	data=JSON.stringify(data);
	var dataList=""
	var rows = $('#DHCEQReturn').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) 
	{
		var oneRow=rows[i]
		//  begin add by jyp 2018-12-19
		var RLInStockListDR=(typeof rows[i].RLInStockListDR=='undefined')?"":rows[i].RLInStockListDR
    	var RLEquipDR=(typeof rows[i].RLEquipDR=='undefined')?"":rows[i].RLEquipDR
    	var RLReturnQtyNum=(typeof rows[i].RLReturnQtyNum=='undefined')?"":rows[i].RLReturnQtyNum
    	
    	
    	if ((RLEquipDR=="")&&(RLInStockListDR==""))
    	{
	   		messageShow("alert","error","错误提示","第"+(i+1)+"行数据为空!请先填写数据.");
			return 
		}//modified by ZY0230 20200513
		else
		{
			if (RLInStockListDR=="") 
			{
				rows[i].RLBatchFlag="N";
			}
			else
			{
				rows[i].RLBatchFlag="Y";
			}
		}
		if (RLReturnQtyNum=="")
		{
			messageShow("alert","error","错误提示","第"+(i+1)+"行数据退货数量不能为空!");
			return
		}
		//add by csj 20190828 单台设备数量只能为1
		if((RLEquipDR!="")&&(RLInStockListDR==""))
		{
			if(RLReturnQtyNum!=1){
				messageShow("alert","error","错误提示","第"+(i+1)+"行数据退货数量有误!");
				return
			}
			
		}
		//  end add by jyp 2018-12-19
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+"&"+RowData
		}
		
	}
	if (dataList=="")
	{
		messageShow("alert","error","错误提示","明细列表不能为空!");
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSReturn","SaveData",data,dataList,"0");
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
	    //window.location.reload()
		var ROutTypeDR=getElementValue("ROutTypeDR");
		var WaitAD=getElementValue("WaitAD"); 
		// ZY0234   20200624	
		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&OutTypeDR="+ROutTypeDR;
		if(ROutTypeDR=="1")
		{
			url="dhceq.em.return.csp?"+val
		}
		else
		{
			url="dhceq.em.outstock.csp?"+val
		}
	    window.location.href= url;
	}
	else
    {
		messageShow("alert","error","错误提示","保存失败,错误信息:"+jsonData.Data);
		return
    }
}
//删除按钮操作
function BDelete_Clicked()
{
	if (RRowID=="")
	{
		messageShow("alert","error","错误提示","没有单据可删除!");
		return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSReturn","SaveData",RRowID,"","1");
	jsonData=JSON.parse(jsonData)
	
	if (jsonData.SQLCODE==0)
	{
		var QXType=getElementValue("QXType");
		var ROutTypeDR=getElementValue("ROutTypeDR");
		// ZY0234   20200624	
		var val="&RowID="+jsonData.Data+"&OutTypeDR="+ROutTypeDR+"&WaitAD=off&QXType="+QXType;
		if(ROutTypeDR=="1")
		{
			url="dhceq.em.return.csp?"+val
		}
		else
		{
			val="&OutTypeDR=&WaitAD=off&QXType="+QXType;	//add by csj 20190828 减少单删除后应将相关参数清空
			url="dhceq.em.outstock.csp?"+val
		}
	    window.location.href= url;
	}
	else
    {
		messageShow("alert","error","错误提示","删除失败,错误信息:"+jsonData.Data);a
		return
    }
}
//提交按钮操作
function BSubmit_Clicked()
{
	var AutoCancelDepre=0		//modified by czf 2020-04-27 begin
	var ResumeDepreFlag=0
	//Modifed BY QW20200403 BUG:QW0057 begin
	var RowID=getElementValue("RRowID");
	if (RowID=="") return;
	if (getElementValue("ROutTypeDR")==1)		//退货
	{
		var NextFlowStep=getElementValue("NextFlowStep");
		var NextRoleDR=getElementValue("NextRoleDR");
		var LastStepFlag=tkMakeServerCall("web.DHCEQ.EM.BUSReturn","GetLastStepFlag","15",RowID,NextFlowStep,NextRoleDR);
		if (LastStepFlag=="Y")
		{
			ResumeFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","302012");		//退货恢复折旧标志 0或空：不处理，1：提示处理，2：后台处理
			if(ResumeFlag==1)
			{
				messageShow("confirm","info","提示","将恢复设备月报、台帐、快照、折旧信息，是否处理?",""
				,function(){
					ResumeDepreFlag=1
					Submit(AutoCancelDepre,RowID,ResumeDepreFlag)
					}
				,function(){
					ResumeDepreFlag=0
					Submit(AutoCancelDepre,RowID,ResumeDepreFlag)
				});
			}
			else if(ResumeFlag==2)
			{
				ResumeDepreFlag=1
				Submit(AutoCancelDepre,RowID,ResumeDepreFlag)
			}
			else
			{
				var CheckResult=tkMakeServerCall("web.DHCEQ.EM.BUSReturn","CheckReturnDepre",RowID);
				if (CheckResult=="-1")
				{
					messageShow("confirm","info","提示","明细设备中当月存在折旧,是否冲减?",""
					,function(){
						AutoCancelDepre=1
						Submit(AutoCancelDepre,RowID,ResumeDepreFlag)
						}
					,function(){
						Submit(AutoCancelDepre,RowID,ResumeDepreFlag)
					});
				}
				if (CheckResult=="-2")
				{
					messageShow("confirm","info","提示","明细设备中存在多个月份折旧,是否冲减?",""
					,function(){
						AutoCancelDepre=1
						Submit(AutoCancelDepre,RowID,ResumeDepreFlag)
						}
					,function(){
						Submit(AutoCancelDepre,RowID,ResumeDepreFlag)
					});
				}
				if (CheckResult=="")     //add by wy 2020-4-27 1290939
				{
					Submit(AutoCancelDepre,RowID,ResumeDepreFlag)

				}

			}
			return;
		}
	}
	Submit(AutoCancelDepre,RowID,ResumeDepreFlag)		//modified by czf 2020-04-27 end
	//Modifed BY QW20200403 BUG:QW0057 End
}
//取消提交按钮操作
function BCancelSubmit_Clicked()
{
	var combindata=getValueList();
	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSReturn","CancelSubmitData",combindata,getElementValue("CurRole"));
    var RtnObj=JSON.parse(Rtn)
	if (RtnObj.SQLCODE==0)
	{
		var ROutTypeDR=getElementValue("ROutTypeDR")
		//ZY0234   20200624	
		var val="&RowID="+RtnObj.Data+"&OutTypeDR="+ROutTypeDR;
		if(ROutTypeDR=="1")
		{
			url="dhceq.em.return.csp?"+val
		}
		else
		{
			url="dhceq.em.outstock.csp?"+val
		}
	    window.location.href= url;
	}
	else
    {
		messageShow("alert","error","错误提示","取消提交失败,错误信息:"+jsonData.Data);
		return
    }
}

function getValueList()
{
	var ValueList="";
  	ValueList=getElementValue("RRowID") ;				//1
  	ValueList=ValueList+"^"+getElementValue("RReturnLocDR") ;	//2
  	ValueList=ValueList+"^"+getElementValue("RProviderDR") ;	//3
  	ValueList=ValueList+"^"+getElementValue("RReturnDate") ;	//4
  	ValueList=ValueList+"^"+getElementValue("RRemark") ;	//5
  	ValueList=ValueList+"^"+getElementValue("REquipTypeDR") ;	//6
  	ValueList=ValueList+"^"+getElementValue("RStatCatDR") ;  		//7
  	ValueList=ValueList+"^"+getElementValue("ROutTypeDR") ;	//8
  	ValueList=ValueList+"^";	//9
  	ValueList=ValueList+"^";	//10
  	ValueList=ValueList+"^";	//11
  	ValueList=ValueList+"^";	//12
	ValueList=ValueList+"^"+session['LOGON.USERID'];	//13
	ValueList=ValueList+"^"+getElementValue("CancelToFlowDR");	//14
	ValueList=ValueList+"^"+getElementValue("ApproveSetDR");	//15
	ValueList=ValueList+"^"+getElementValue("RJob");
	ValueList=ValueList+"^";
  	return ValueList;
}

//审核按钮操作
function BApprove_Clicked()
{
	//Modifed BY QW20200403 BUG:QW0057 begin		//modified by czf 1247213 begin
	var AutoCancelDepre=0
	var ResumeDepreFlag=0
	var ResumeFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","302012");		//退货恢复折旧标志 0或空：不处理，1：提示处理，2：后台处理
	if (getElementValue("ROutTypeDR")==1)
	{
		var RowID=getElementValue("RRowID");
	    if (RowID=="") return;
		var NextFlowStep=getElementValue("NextFlowStep");
		var NextRoleDR=getElementValue("NextRoleDR");
		var LastStepFlag=tkMakeServerCall("web.DHCEQ.EM.BUSReturn","GetLastStepFlag","15",RowID,NextFlowStep,NextRoleDR);
		if (LastStepFlag=="Y")
		{
			if(ResumeFlag==1)
			{
				messageShow("confirm","info","提示","将恢复设备月报、台帐、快照、折旧信息，是否处理?",""
				,function(){
					ResumeDepreFlag=1
					Audit(AutoCancelDepre,ResumeDepreFlag)
					}
				,function(){
					Audit(AutoCancelDepre,ResumeDepreFlag)
				});
			}
			else if(ResumeFlag==2)
			{
				ResumeDepreFlag=1      //add by wy 2020-4-27 WY0065
				Audit(AutoCancelDepre,ResumeDepreFlag)
			}
			else
			{
				var CheckResult=tkMakeServerCall("web.DHCEQ.EM.BUSReturn","CheckReturnDepre",RowID);
				if (CheckResult=="-1")
				{
					messageShow("confirm","info","提示","明细设备中当月存在折旧,是否冲减?",""
					,function(){
						AutoCancelDepre=1
						Audit(AutoCancelDepre,ResumeDepreFlag)
						}
					,function(){
						Audit(AutoCancelDepre,ResumeDepreFlag)
					});
				}
				if (CheckResult=="-2")
				{
					messageShow("confirm","info","提示","明细设备中存在多个月份折旧,是否冲减?",""
					,function(){
						AutoCancelDepre=1
						Audit(AutoCancelDepre,ResumeDepreFlag)
						}
					,function(){
						Audit(AutoCancelDepre,ResumeDepreFlag)
					});
				}
				if (CheckResult=="")     //add by wy 2020-4-27 1290939
				{
					Audit(AutoCancelDepre,ResumeDepreFlag)

				}

			}
			return;
		}
	}
	Audit(AutoCancelDepre,ResumeDepreFlag)			//modified by czf 1247213 end
	//Modifed BY QW20200403 BUG:QW0057 End
}
//打印按钮
function BPrint_Clicked()
{
	var RRowID=getElementValue("RRowID");
	if (RRowID=="") return;
	var PrintFlag=getElementValue("PrintFlag");
	
	//Excel打印方式
	if(PrintFlag==0)  
	{
		ReturnPrint(RRowID);
	}
	//add by QW20191022 BUG:QW0032 增加润乾打印方式
	if(PrintFlag==1)
	{
		var ReturnList=tkMakeServerCall("web.DHCEQReturn","GetID",RRowID);
		ReturnList=ReturnList.replace(/\\n/g,"\n");
		var lista=ReturnList.split("^");
		var sort=28; 
		var OutTypeDR=lista[16];
		var No=lista[0];  //凭单号
		var EquipType=lista[sort+5] ; //类组
		var FromLoc=GetShortName(lista[sort+0],"-");//退货部门
		if (OutTypeDR!=1)
		{	var ToDept=GetShortName(lista[sort+8],"-");}	//去向
		else
		{	var ToDept=GetShortName(lista[sort+1],"-");} 	//供应商
		var Maker=lista[sort+2];//制单人
		var ReturnDate=FormatDate(lista[3]);//减少日期
		var PreviewRptFlag=getElementValue("PreviewRptFlag"); //add by wl 2019-11-11 WL0010 begin   增加润乾预览标志
        var fileName=""	;
        if(PreviewRptFlag==0)
        {
			if (OutTypeDR!=1){
       		 fileName="{DHCEQOutStockSPrint.raq(RowID="+RRowID+";RequestNo="+No+";EquipType="+EquipType+";FromLoc="+FromLoc+";ReturnDate="+ReturnDate+";Maker="+Maker+";ToDept="+ToDept+")}";
       		}
       		else
       		{
       		 fileName="{DHCEQReturnSPrint.raq(RowID="+RRowID+";RequestNo="+No+";EquipType="+EquipType+";FromLoc="+FromLoc+";ReturnDate="+ReturnDate+";Maker="+Maker+";ToDept="+ToDept+")}";
       		 }	         

       		 DHCCPM_RQDirectPrint(fileName);
        }
        if(PreviewRptFlag==1)
        { 
			if (OutTypeDR!=1){
	     		 fileName="DHCEQOutStockSPrint.raq&RowID="+RRowID+"&RequestNo="+No+"&EquipType="+EquipType+"&FromLoc="+FromLoc+"&ReturnDate="+ReturnDate+"&Maker="+Maker+"&ToDept="+ToDept ;
			}else{
			     fileName="DHCEQReturnSPrint.raq&RowID="+RRowID+"&RequestNo="+No+"&EquipType="+EquipType+"&FromLoc="+FromLoc+"&ReturnDate="+ReturnDate+"&Maker="+Maker+"&ToDept="+ToDept ;
			  
			}
			DHCCPM_RQPrint(fileName)
        }												//add by wl 2019-11-11 WL0010 end			


	}
			
}
function ReturnPrint(returnid)
{
	if (returnid=="") return;

	var ReturnList=tkMakeServerCall("web.DHCEQReturn","GetID",returnid);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	var lista=ReturnList.split("^");
	
	//获取单子信息
	var sort=28; //2011-03-10 DJ
	var OutTypeDR=lista[16];	
	var OutType=lista[sort+7];
	var No=lista[0];  //凭单号
	var EquipType=lista[sort+5] ; //类组
	var FromLoc=GetShortName(lista[sort+0],"-");//退货部门
	if (OutTypeDR!=1)
	{	var ToDept=GetShortName(lista[sort+8],"-");}	//去向
	else
	{	var ToDept=GetShortName(lista[sort+1],"-");} 	//供应商
	var Maker=lista[sort+2];//制单人
	var ReturnDate=FormatDate(lista[3]);//减少日期
	//alertShow(OutTypeDR+" "+OutType);
	
	var gbldata=tkMakeServerCall("web.DHCEQReturn","GetList",returnid);
	if (gbldata=="") return;
	var RLList=gbldata.split("^");
	rows=RLList.length;
	if (rows>0) rows=rows+1;
	var sumFee=0;
	var sumQty=0;
	var PageRows=6; //每页固定行数
	var Pages=parseInt(rows / PageRows); //总页数-1  
	var ModRows=rows%PageRows; //最后一页行数
	if (ModRows==0) Pages=Pages-1;
	var	TemplatePath=tkMakeServerCall("web.DHCEQStoreMoveSP","GetPath");
	try {
        var xlApp,xlsheet,xlBook;
        
        if (OutTypeDR==1)
        {
	    	var Template=TemplatePath+"DHCEQReturnSP.xls";
        }
        else
        {
	        var Template=TemplatePath+"DHCEQOutStockSP.xls";
	    }
	    
	    xlApp = new ActiveXObject("Excel.Application");
	    for (var i=0;i<=Pages;i++)
	    {
		    xlBook = xlApp.Workbooks.Add(Template);
	    	xlsheet = xlBook.ActiveSheet;
	    	
	    	xlsheet.PageSetup.TopMargin=0;
	    	//医院名称替换 Add By DJ 2011-07-14
	    	xlsheet.cells.replace("[Hospital]",getElementValue("HospitalDesc"))
	    	xlsheet.cells(2,2)=No;  //凭单号
	    	xlsheet.cells(2,6)=ReturnDate;  //减少日期
	    	xlsheet.cells(2,8)=EquipType; //类组
	    	xlsheet.cells(3,2)=FromLoc;//退货部门
	    	if (OutTypeDR==1)
	    	{
		    	xlsheet.cells(3,6)=ToDept;//供应商
	    	}
	    	else
	    	{
		    	xlsheet.cells(3,6)=OutType;  //减少类型
		    	xlsheet.cells(3,8)=ToDept;//供应商
	    	}
	    	
	    	var OnePageRow=0;
	    	if (ModRows==0)
	    	{
		    	OnePageRow=PageRows;
	    	}
	    	else
	    	{
	    		if (i==Pages)
	    		{
		    		OnePageRow=ModRows;
	    		}
		    	else
		    	{
			    	OnePageRow=PageRows;
		    	}
	    	}	    	
	    	var FeeAll=0;
			//var sort=9;
			var sort=13;
			for (var Row=1;Row<=OnePageRow;Row++)
			{
				var Location=i*PageRows+Row-1;
				if (Location==rows-1)
				{
					//xlsheet.Rows(Row+5).Insert();
					xlsheet.cells(Row+4,1)="合计";//设备名称
					xlsheet.cells(Row+4,4)=sumQty;//数量
					xlsheet.cells(Row+4,6)=sumFee;//总价
				}
				else
				{
				var RLID=RLList[Location];
				var Data=tkMakeServerCall("web.DHCEQReturnList","GetID",RLID); //modify by jyp 2018-12-19
				var List=Data.split("^");
				//xlsheet.Rows(Row+5).Insert();
				xlsheet.cells(Row+4,1)=List[sort+4];//设备名称
				//xlsheet.cells(Row+5,2)=List[1];//生产厂商
				xlsheet.cells(Row+4,2)=List[sort+5];//机型
				xlsheet.cells(Row+4,3)=List[sort+8];//单位
				xlsheet.cells(Row+4,4)=List[4];//数量
				xlsheet.cells(Row+4,5)=List[5];//原值
				var FeeAllm=List[4]*List[5];
				xlsheet.cells(Row+4,6)=FeeAllm;//总价
				
				//xlsheet.cells(Row+4,7)=List[sort+9];//发票号
				xlsheet.cells(Row+4,7)=List[sort+10];//设备编号
				
				//xlsheet.cells(Row+4,9)=List[sort+11];//合同号
				//xlsheet.cells(Row+4,10)=List[sort+3];//退货原因
				xlsheet.cells(Row+4,8)=List[8];//备注
				FeeAll=FeeAll+FeeAllm;
				sumFee=sumFee+FeeAllm;
				sumQty=sumQty+List[4]*1;
				}				
	    	}
	    //xlsheet.cells(OnePageRow+7,7)="制单人:"+Maker;
	    //xlsheet.Rows(OnePageRow+6).Delete();	    
	    //xlsheet.cells(OnePageRow+9,2)=ReturnDate;
	    //xlsheet.cells(OnePageRow+9,6)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";   //时间
	    xlsheet.cells(11,8)="制单人:"+Maker;
	    xlsheet.cells(12,8)="第"+(i+1)+"页 "+"共"+(Pages+1)+"页";     
    	var obj = new ActiveXObject("PaperSet.GetPrintInfo");
	    var size=obj.GetPaperInfo("DHCEQInStock");
	    if (0!=size) xlsheet.PageSetup.PaperSize = size;
	    xlsheet.printout; //打印输出
	    //xlBook.SaveAs("D:\\Return"+i+".xls");   //lgl+
	    xlBook.Close (savechanges=false);
	    
	    xlsheet.Quit;
	    xlsheet=null;
	    }
	    xlApp=null;
	} 
	catch(e)
	{
		alertShow(e.message);
	}
}
//
function endEditing(){
		if (editIndex == undefined){return true}
		if ($('#DHCEQReturn').datagrid('validateRow', editIndex)){
			$('#DHCEQReturn').datagrid('endEdit', editIndex);
    		var rows = $("#DHCEQReturn").datagrid('getRows');
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
function onClickRow(index){
	if (getElementValue("ROutTypeDR")=="1"&&getElementValue("RProviderDR")=="")	//modified by csj 20190912 供应商退货必须，减少非必须 需求号：1028765
	{
		messageShow("alert","error","错误提示","供应商不能为空!");
		return
	}		//add by yh 20190718
		
	var Status=getElementValue("RStatus");
	if (Status>0) return
	if (editIndex!=index) 
	{
		if (endEditing())
		{
			$('#DHCEQReturn').datagrid('selectRow', index).datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $.extend({},$('#DHCEQReturn').datagrid('getRows')[editIndex]);
		} else {
			$('#DHCEQReturn').datagrid('selectRow', editIndex);
		}
	}
	else
	{
		endEditing();
	}
}
//填充数据
function getInStockList(index,data)
{
	//Begin add by jyp 2018-12-19
	var rows = $('#DHCEQReturn').datagrid('getRows'); 
	if(data.TEquipID!="")
	{
		for(var i=0;i<rows.length;i++){
			///modified by ZY0226 2020-04-29
			if((rows[i].RLEquipDR==data.TEquipID)&&(editIndex!=i))
			{
				messageShow('alert','error','提示','当前选择行与明细中第'+(i+1)+'行重复!')
				return;
			}
		}
	}
	else
	{
		for(var i=0;i<rows.length;i++){
			///modified by ZY0226 2020-04-29
			if((rows[i].RLInStockListDR==data.TInStockListID)&&(editIndex!=i))
			{
				messageShow('alert','error','提示','当前选择行与明细中第'+(i+1)+'行重复!')
				return;
			}
		}
	}
	//end add by jyp 2018-12-19
	//入库明细表中已存在改设备
	var rowData = $('#DHCEQReturn').datagrid('getSelected');
	//var Length=ObjSources.length
	/*
	var LastSourceType=ObjSources[index].SourceType //变动之前的SourceType
	var LastSourceID=ObjSources[index].SourceID //变动之前的SourceID
	
	if (list[2]==0)
	{
		for (var i=0;i<Length;i++)
		{
			if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="2")&&(ObjSources[i].SourceID==list[1])&&(selectrow!=i)) //add by zx 2015-01-05
			{
				var ObjTRow=document.getElementById("TRowz"+i);
				if (ObjTRow)  var TRow=ObjTRow.innerText;
				alertShow("选择行与第"+(TRow)+"行是重复的设备!")
				return;
			}
		}
		ObjSources[selectrow]=new SourceInfo("2",list[1]);
		list[2]=""
	}
	else
	{
		for (var i=0;i<Length;i++)
		{
			if ((tableList[i]=="0")&&(ObjSources[i].SourceType=="1")&&(ObjSources[i].SourceID==list[2])&&(selectrow!=i))
			{
				var ObjTRow=document.getElementById("TRowz"+i);
				if (ObjTRow)  var TRow=ObjTRow.innerText;
				alertShow("选择行与第"+(TRow)+"行是重复的入库单!")
				return;
			}
		}
		ObjSources[selectrow]=new SourceInfo("1",list[2]);
	}
	*/
	rowData.RLEquip=data.TName
	rowData.RLEquipDR=data.TEquipID
	//ZY0234   20200624
	rowData.RLInStockListDR=""
	if (data.TInStockListID>0)
	{
		rowData.RLInStockListDR=data.TInStockListID
		rowData.RLEquipDR=""
	}
	rowData.RLModel=data.TModel
	rowData.RLReturnNum=data.TQuantity
	rowData.RLManuFactory=data.TManuFactory
	rowData.RLUnit=data.TUnit
	rowData.RLReturnFee=data.TOriginalFee; //Modify by zx 2019-12-19 小数位部分清空bug修复 BUG ZX0072
	rowData.RLTotalFee=(data.TQuantity*data.TOriginalFee).toFixed(2)
	rowData.RLInvoiceNo=data.TInvoiceNo
	var objGrid = $("#DHCEQReturn"); 
	var QuantityEditor = objGrid.datagrid('getEditor', {index:editIndex,field:'RLReturnQtyNum'});
	$(QuantityEditor.target).val(data.TQuantity);
	var NameEditor = objGrid.datagrid('getEditor', {index:editIndex,field:'RLEquip'});
	$(NameEditor.target).combogrid("setValue",data.TCommonName);  //modify by jyp20190530
	$('#DHCEQReturn').datagrid('endEdit',editIndex);
	$('#DHCEQReturn').datagrid('beginEdit',editIndex);
}

//Add By DJ 2017-11-20
function GetAllListInfo()
{
  	var objtbl=document.getElementById('t'+Component);
	var rows=tableList.length
	var valList="";
	for(var i=1;i<rows;i++)
	{
		if (tableList[i]=="0")
		{
			var TRowID=GetElementValue('TRowIDz'+i);
			if(valList!="")	{valList=valList+"&";}
			valList=valList+i+"^"+TRowID;
		}
	}
	return valList
}

function getReturnReason(index,data)
{
	var rowData = $('#DHCEQReturn').datagrid('getSelected');
	rowData.RLReturnReasonDR=data.TRowID
	var objGrid = $("#DHCEQReturn"); 
	var ReturnReasonEditor = objGrid.datagrid('getEditor', {index:editIndex,field:'RLReturnReason'});
	$(ReturnReasonEditor.target).combogrid("setValue",data.TDesc);
	$('#DHCEQReturn').datagrid('endEdit',editIndex);
	$('#DHCEQReturn').datagrid('beginEdit',editIndex);
}
//新建公用组件取参数方法。
function getParam(ID)
{
	if (ID=="FromLocDR"){return getElementValue("RReturnLocDR")}
	else if (ID=="EquipTypeDR"){return getElementValue("REquipTypeDR")}
	else if (ID=="StatCatDR"){return getElementValue("RStatCatDR")}
	else if (ID=="ProviderDR"){return getElementValue("RProviderDR")}
	else if (ID=="UseLocDR"){return getElementValue("RUseLocDR")}
	//add by czf 2020-05-07 1304193
	else if (ID=="Flag")
	{
		if (editIndex == undefined) return ""; 
		var flagEdt = $("#DHCEQReturn").datagrid('getEditor', {index:editIndex,field:'RLBatchFlag'}); 
		return flagEdt==null?'':flagEdt.target.checkbox("getValue");
	}
}

function BUpdateEquipsByList(editIndex)
{
	var rowData =  $("#DHCEQReturn").datagrid("getRows")[editIndex];
	var inStockListDR=(typeof rowData.RLInStockListDR == 'undefined') ? "" : rowData.RLInStockListDR;
	var equipDR=rowData.RLEquipDR;
	if ((inStockListDR=="")&&(equipDR=="")) return;
	var quantityNum=(typeof rowData.RLReturnQtyNum == 'undefined') ? "" : rowData.RLReturnQtyNum;
	if (quantityNum=="") return;
	
	var url="dhceq.em.updateequipsbylist.csp?";
	url=url+"SourceID="+inStockListDR;
	url=url+"&QuantityNum="+quantityNum;
	url=url+"&Job="+getElementValue("RJob");
	url=url+"&Index="+editIndex;
	var RLRowID = (typeof rowData.RLRowID == 'undefined') ? "" : rowData.RLRowID;
	url=url+"&MXRowID="+RLRowID;
	url=url+"&StoreLocDR="+getElementValue("RReturnLocDR");
	url=url+"&Status="+getElementValue("RStatus");
	url=url+"&Type=2";
	url=url+"&EquipID="+equipDR;
	showWindow(url,"设备出厂编号列表","","","icon-w-paper","modal","","","small",listChange);  //modify by lmm 2019-02-19 增加回调
}
function listChange(index,quantity)
{
	$('#DHCEQReturn').datagrid('beginEdit',index);    //add by jyp 2019-05-20
	var rowData =  $("#DHCEQReturn").datagrid("getRows")[index];
	var objGrid = $("#DHCEQReturn");        // 表格对象
    var quantityEdt = objGrid.datagrid('getEditor', {index:index,field:'RLReturnQtyNum'}); // 数量
	$(quantityEdt.target).val(quantity);
	var rowData =  $('#DHCEQReturn').datagrid('getSelected');
	var originalFee=rowData.RLReturnFee;
	rowData.RLTotalFee=quantity*originalFee;
	$('#DHCEQReturn').datagrid('endEdit',index);     //modify by jyp 2019-05-20
	creatToolbar();
}
//Add BY QW20200403 BUG:QW0057 提交:执行方法
function Submit(AutoCancelDepre,RowID,ResumeDepreFlag)
{
	var combindata=getValueList();
  	var valList=totalSum("DHCEQReturn","RQuantityNum");
  	if (valList==0)
  	{
	  	messageShow("alert","error","错误提示","保存失败,错误信息:"+t["-1003"]);
	  	return;
	}
	var CheckConfig=tkMakeServerCall("web.DHCEQReturnNew","CheckConfigDR",RowID);
  	if (CheckConfig!="") 
  	{
	  	alertShow("本退货单明细包含有配置设备,如需退货请另行添加至明细处理!!!")
  	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSReturn","SubmitData",combindata,AutoCancelDepre,ResumeDepreFlag);	//modified by czf 1247213
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
    {
		var ROutTypeDR=getElementValue("ROutTypeDR");
		var WaitAD=getElementValue("WaitAD"); 
		//ZY0234   20200624
		var val="&RowID="+jsonData.Data+"&WaitAD="+WaitAD+"&OutTypeDR="+ROutTypeDR;
		if(ROutTypeDR=="1")
		{
			url="dhceq.em.return.csp?"+val
		}
		else
		{
			url="dhceq.em.outstock.csp?"+val
		}
		window.location.href=url;
	}
	else
    {
		messageShow("alert","error","错误提示","提交失败,错误信息:"+jsonData.Data);
		return
    }
}
//Add BY QW20200403 BUG:QW0057 审核:执行方法
function Audit(AutoCancelDepre,ResumeDepreFlag)
{
	var combindata=getValueList();
	var curRole=getElementValue("CurRole");
  	if (curRole=="") return;
	var roleStep=getElementValue("RoleStep");
  	if (roleStep=="") return;
  	var Rtn=tkMakeServerCall("web.DHCEQ.EM.BUSReturn","AuditData",combindata,curRole,roleStep,"",AutoCancelDepre,ResumeDepreFlag);	//modified by czf 1247213
    var RtnObj=JSON.parse(Rtn)
    
    if (RtnObj.SQLCODE!=0)		//modified by czf 2020-05-07 1304188
    {
	    messageShow("alert","error","错误提示","审核失败,错误信息:"+RtnObj.Data);
	    
    }
    else
    {
	    window.location.reload()

    }
}