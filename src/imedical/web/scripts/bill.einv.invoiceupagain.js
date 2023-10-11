/*注意调用税控Ocx打印放开,安装税控.exe程序，确认路径和程序路径是否一致。
document.write("<object ID='sk' style = 'display:none' CLASSID='CLSID:003BD8F2-A6C3-48EF-9B72-ECFD8FC4D49F' CODEBASE='../addins/client/NISEC_SKSCX.OCX#version=1,0,0,1' VIEWASTEXT>");
document.write("</object>");
*/
/**
 * FileName: bill.einv.invoiceupagain.js
 * Author: ZhaoZW
 * Date: 2019-09-16
 * Description:
 */
 
 /* add  guoyunlong
 备注调用博思JS打印是需要放开下面代码
 1.引用博思JS,将博思JS放到scripts路径下   --industry-proxy-app.js
 2.安装博思打印小助手                     --财政票据客户端综合管理组件-v1.6.5.exe
 3.测试打印调用打印方法打印
 4.对应参数换成测试医院的数据
 */
 /*  
 var industry = new BsIndustryApi({'appId':'CZSRMYY2711079',
        'appKey':'949d65daf18f83dfa9a2e803e3',
        'type':'medical',
        'url':'http://172.16.1.31:7520/medical-web/'});
 */
 var UserID=session['LOGON.USERID']
 var HOSPID=session['LOGON.HOSPID']
            
$(function(){
	setPageLayout(); //页面布局初始化
	setElementEvent(); //页面事件初始化
});

function setPageLayout(){
	//获取当前日期
	var nowDate = new Date().getFullYear() + "-" + (new Date().getMonth() + 1) + "-" + new Date().getDate();
	//设置开始日期值
	$('#IUDStDate').datebox('setValue', nowDate);
	//设置结束日期值
	$('#IUDEdDate').datebox('setValue', nowDate);
	$HUI.combobox('#IUDPayAdmTypeCombo',{
		valueField:'DicCode', 
		textField:'DicDesc',
		panelHeight:"auto",
		url:$URL,
		editable:false,
		method:"GET",
		onBeforeLoad:function(param)
		{
			param.ClassName="BILL.EINV.BL.COM.DicDataCtl"
			param.QueryName="QueryDicDataInfo"
			param.ResultSetType="array";
			param.Type="BusinessType"          //业务类型字段Type="LogicType"
		}
		,onLoadSuccess:function(){
			if(LogicTypeLoadFlg=="0"){
				//alert("LogicTypeLoadFlg="+LogicTypeLoadFlg);
				LogicTypeLoadFlg="1";
		
				var LogicArr=$('#IUDPayAdmTypeCombo').combobox("getData");
				var AllLogicType={
					DicCode:"ALL",
					DicDesc:"全部"
				};
				LogicArr.splice(0, 0, AllLogicType);             //在指定位置添加元素,第一个参数指定位置,第二个参数指定要删除的元素,如果为0,则追加
				$('#IUDPayAdmTypeCombo').combobox('loadData', LogicArr);
			}
			
			$('#IUDPayAdmTypeCombo').combobox('setValue','ALL');
		}
	});
	
	$("#EINVFlg").combobox({
		valueField:'code',
		textField:'desc',
		data:[{
			'code':'ALL',
			'desc':'全部'			
		},{
			'code':'0',
			'desc':'未开票',
			'selected':true
		},{
			'code':'1',
			'desc':'已开票'
		}]
	});

	//初始化院区
	$HUI.combobox('#Hosptial',{
		valueField:'HospitalDr', 
		textField:'HospitalNM',
		panelHeight:"auto",
		url:$URL,
		editable:false,
		method:"GET",
		onBeforeLoad:function(param){ 
			param.ClassName="BILL.EINV.BL.COM.InvPageInfoCtl"
			param.QueryName="QueryGetHospital"
			param.ResultSetType="array"
			param.HospDr=HOSPID              //根据登录院区过滤
		}
	});
	//$('#Hosptial').combobox('setValue','ALL');
	
	
	
	$HUI.datagrid('#tBillIUD',{
		fit:true,
		pagination:true,
		pageSize:20,
		pageList:[20,40,60],
		singleSelect:true,
		//singleSelect:false,
		selectOnCheck:false,
		checkOnSelect:false,
		striped:true,
		rownumbers:false,
		toolbar: [],
		url:$URL,
		columns:[[    
			{field:'checkbox',checkbox:true}, 
			{field:'PatRegNo',title:'登记号',width:80},
			{field:'PatName',title:'姓名',width:80},
			{field:'PacAdmReasonDesc',title:'费别',width:100},
			{field:'InvprtAmount',title:'票据金额',width:90, align:'right'},
			{field:'LocgicType',title:'业务类型',width:80
				,formatter:function(value,row){
					var rtn=GetLogicTypeDesc(value);
					return rtn;
				}
			},
			{field:'SFTFFlg',title:'收费/退费',width:80
				,styler: function(value,row,index){
					var rtnStyle="";
					if(row.SFTFFlg=="退费"){
						rtnStyle= 'color:red;';
					}
					
					return rtnStyle
				}
			},
			{field:'EInvFlg',title:'上传标志',width:150,
				styler: function(value,row,index){
					var rtnStyle="";
					if(row.EInvFlg=="1"){             //已开票标绿显示
						rtnStyle= 'background-color:#00ffff;';
					}
					
					return rtnStyle
				},
				formatter:function(index,value){
					var rtn=""
					if(value.EInvFlg=="1"){
						rtn="已上传"
					}else{
						rtn="未上传"
					}
					return rtn;
				}
				
			},
			{field:'Invprtrowid',title:'his发票Dr',width:100},
			{field:'InitRowid',title:'his原发票Dr',width:100},
			{field:'SFDate',title:'收费日期',width:70},
			{field:'SFTime',title:'收费时间',width:70},
			{field:'SFUserDr',title:'收费员Dr',width:100,hidden:true},
			{field:'SFUserName',title:'收费员',width:100},
			{field:'AdmLocName',title:'就诊科室',width:100},
			{field:'AdmHospitalDr',title:'院区Dr',width:100,hidden:true},
			{field:'AdmHospitalNM',title:'院区名称',width:150},
			
			{field:'EInvCode',title:'票据代码',width:100},
			{field:'EInvSeriNo',title:'票据号',width:100},
			{field:'EInvRandom',title:'校验码',width:80},
			{field:'PDFUrl',title:'PDFUrl',width:100},
			{field:'BusinessDr',title:'业务表dr',width:100,hidden:true},
			{field:'PictureUrl',title:'地址URL',width:200,
				formatter: function (value,row, index) {
					//alert(row.PictureUrl);
					if (value) {
							return "<a href="+ row.PictureUrl+" >" + row.PictureUrl + "</a>";
							return "<a href='javascript:;' onclick=\"printEInv(\'" + row.PictureUrl + "\')\">" + row.PictureUrl + "</a>";
					}
				}
			}
			/*
			{field:'IUDInvDr',title:'发票表指针'},    
			{field:'IUDCreatAmt',title:'开票金额'},    
			{field:'IUDBillBatchCode',title:'电子票据代码'},
			{field:'IUDBillBatchNo',title:'电子票据号码'},
			{field:'IUDPayAdmType',title:'票据类型',hidden:true},
			{field:'IUDPayAdmTypeDesc',title:'票据类型'},
			{field:'USRName',title:'上传人'},
			{field:'IUDDate',title:'上传日期'},
			{field:'IUDUplodeFlag',title:'上传标志'},
			{field:'IUDHospDr',title:'院区指针'},
			{field:'IUDCreatDate',title:'开票日期',hidden:true},
			{field:'IUDCreatTime',title:'开票时间',hidden:true},
			{field:'IUDBillBatchStatus',title:'电子票据状态'},
			{field:'IUDBillisScarlet',title:'是否已开红票'},
			{field:'PrintType',title:'票据模式'},
			{field:'InvStyle',title:'票据种类'},
			{field:'PrintFlag',title:'是否打印纸质票据',
			formatter: function(value){
					if(value == "0"){
						return '未打印'
					}
					if(value == "1"){
						return '已打印'	
					}
					if(value == ""){
						return '其他'	
					}
				}
        	},
			{field:'RateStatus',title:'纸质生成状态',
			 formatter: function(value){
					if(value == "0"){
						return '未生成'
					}
					if(value == "1"){
						return '已生成'	
					}
					if(value == "2"){
						return '失败'	
					}
				}
			}
			*/
		]],
		fitColumns:true
	});
}

/// 功能说明：根据业务类型获取业务名称
var LogicTypeLoadFlg="0";
function GetLogicTypeDesc(LogicType){
	var LogicName="";
	
	var LogicArr=$("#IUDPayAdmTypeCombo").combobox("getData");
	var LogicLen=LogicArr.length;
	var objLogic=null;
	var LogicTypeTmp="";   //业务类型编码
	for(index=0; index<LogicLen; index++){
		objLogic=LogicArr[index];
		LogicTypeTmp=objLogic.DicCode;    //业务类型编码
		if(LogicTypeTmp==LogicType){
			LogicName=objLogic.DicDesc;   //业务类型名称
			break;
		}
	}
	
	return LogicName;
}

function setElementEvent(){
	///查询
	$('#IUDSearch').click(function(){  
        queryBillIUDInfo();
    });
    ///补开 所有选择的电子票  
	$('#IUDUploadSelected').click(function(){
		//upDataInfo();
		InvoiceMuti();
	});
    
    ///开电子票
	$('#IUDUpload').click(function(){
		UpLoadEInvInfo();
	});
	///开纸质票
    $('#IUDUploadPInv').click(function(){  
        UpLoadPInvInfo();
    });
    ///票据撤销
    $('#IUDCancel').click(function(){  
        InvCancel();
    });
       //打印发票OCX
    $('#IUDPrint').click(function(){  
        //InvPrintOCX();
        EInvPrintAll();      //批量打印
    });
    
     //add by xubaobao 2020 07 23 
    $('#rmarkNo').on('keydown', function (e){			//登记号回车事件
		rmarkNoKeyDown(e);
	});	
	
     //add by suhuide 2021 12 28 
    $('#CardNo').on('keydown', function (e){			//卡号回车事件
		cardNoKeydown(e);
	});	
	
	
	///电票换开
    $('#IUDReInvoice').click(function(){  
        ReInvoice();
    });
    
    //读卡
	$HUI.linkbutton("#readCard",{
		onClick: function () {
			readHFMagCardClick();
		}
	});
	//打印发票明细
    $('#IUDPrintDetails').click(function(){  
        //EInvPrintByPrt();
        InvEPrintDetails();
    });
    
    //打印小条
    $('#PrintDirect').click(function(){  
        PrintDirectInfo();
    });
    
    
}

//add by xubaobao 2020 07 23  增加卡号查询功能
function rmarkNoKeyDown(e){

	var key = websys_getKey(e);
	if (key == 13){
		GetRegNo();
		queryBillIUDInfo();
	}
}

//登记号补零  
function GetRegNo(){
	var RegNo=$('#rmarkNo').val();
	var PRegNoLength=10-RegNo.length;      	
	for (var i=0;i<PRegNoLength;i++){
		RegNo="0"+RegNo;			
	}
	$('#rmarkNo').val(RegNo);	
}

/**
 * 卡号回车事件
 * @create 2021-12-28
 * @author Suhuide
 */
function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		//var cardNo = getValueById("CardNo");		//HISUI不支持getValueById()、setValueById()方法？？
		var cardNo = $('#CardNo').val();
		if (!cardNo) {
			return;
		}
		DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
	}
}



function magCardCallback(rtnValue) {
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		//setValueById("CardNo", myAry[1]);
		//patientId = myAry[4];
		//setValueById("rmarkNo", myAry[5]);
		$('#CardNo').val(myAry[1]);
		patientId = myAry[4];
		$('#rmarkNo').val(myAry[5]);

		break;
	case "-200":
		$.messager.alert("提示", "卡无效", "info", function () {
			focusById("CardNo");
		});
		break;
	case "-201":
		//setValueById("CardNo", myAry[1]);
		//patientId = myAry[4];
		//setValueById("rmarkNo", myAry[5]);
		$('#CardNo').val(myAry[1]);
		patientId = myAry[4];
		$('#rmarkNo').val(myAry[5]);
		break;
	default:
	}
	
	if (patientId != "") {
		queryBillIUDInfo();
	}
}


///查询未上传成功的电子发票数据
function queryBillIUDInfo(){
	var IUDStDate = $('#IUDStDate').datebox('getValue');
	var IUDEdDate = $('#IUDEdDate').datebox('getValue');
	var IUDAdmType= $('#IUDPayAdmTypeCombo').combobox('getValue');
	var Hosital=$('#Hosptial').combobox('getValue');
	var RegNo=$('#rmarkNo').val();
	var EInvFlg=$("#EINVFlg").combobox("getValue");
	var Extstr=Hosital+"^"+RegNo+"^"+EInvFlg;
	//alert(IUDStDate+"^"+IUDEdDate+"^"+IUDAdmType)
	var queryParam={
		ClassName:'BILL.EINV.BL.COM.InvPageInfoCtl',
		QueryName:'QueryInvUploadInfo',
		IUDStDate:IUDStDate,
		IUDEdDate:IUDEdDate,
		IUDAdmType:IUDAdmType,
		Extstr:Extstr
	}
	$('#tBillIUD').datagrid({
		url:$URL,
		queryParams:queryParam
	})	
	//$('#tBillIUD').datagrid('load')
	
}
///开电子票
function UpLoadEInvInfo()
{
	var PathCode="";
	//Invoice(PathCode);
	Invoice(PathCode);
}

///开纸质票
function UpLoadPInvInfo()
{
	var PathCode="PInvoice" ;
	Invoice(PathCode);
	
}
/*
//发票开具
function Invoice(PathCode)
{
	var row = $('#tBillIUD').datagrid('getSelected');
	if(row==null){
		alert("请选择一条记录后再申请开票!");
		return ;
	}
	//已经开具成功的不允许在重复开具发票
	if(row.EInvFlg=="1")
	{
		alert("该发票已开具发票,不允许重复开具！");
		return ;
	}
	
	var	dataStr=row.LocgicType+"^"+row.Invprtrowid+"^"+row.InitRowid+"^"+PathCode
	alert(dataStr);
	var rtn=$cm({
				ClassName:"BILL.EINV.BL.COM.InvPageInfoCtl",
				MethodName:"DealData",
				dataStr:dataStr
	},false);
	if (rtn=="0")
	{
		alert("开具成功")
		///开具成功后，重新弄加载这一条数据
		UpDateInvInfo(dataStr);
	}else{
		alert("开具失败")
		}				
}*/

/// 功能说明：一次开一张票
function Invoice(PathCode){
	$('#IUDUpload').attr("disabled",true)     //禁用按钮
	var row = $('#tBillIUD').datagrid('getSelected');
	if(row==null){
		alert("请选择一条记录后再申请开票!");
		return ;
	}
	//已经开具成功的不允许在重复开具发票
	if(row.EInvFlg=="1")
	{
		alert("该发票已开具发票,不允许重复开具！");
		return ;
	}
	
	var ErrMsg="";
	var AllRecsArr=[];
	AllRecsArr.push(row);
	InvoiceDo(AllRecsArr, 0, ErrMsg, PathCode);
}

/// 功能说明：一次性开多张票
function InvoiceMuti(){
	var rows = $('#tBillIUD').datagrid('getChecked');
	if(rows.length>0){
		var PathCodeTmp="";
		var ErrMsgTmp="";
		InvoiceDo(rows, 0, ErrMsgTmp, PathCodeTmp);   逐个开票
	}else{
		alert("请选择一条记录!");
	}
}

/// 功能说明：发票开具后台方法调用
function InvoiceDo(CheckedRecs, i, ErrMsg, PathCode){
	
	var ErrMsgTmp="";
	var NextIndex=0;
	var AllRecLen=CheckedRecs.length;   //本次开票数目
	var nowInvRecInfo=CheckedRecs[i];   //当前票据记录
	var InvRecIndex=$('#tBillIUD').datagrid('getRowIndex', nowInvRecInfo);   //当前票据所在行索引
	
	var	dataStr=nowInvRecInfo.LocgicType+"|"+nowInvRecInfo.Invprtrowid+"|"+nowInvRecInfo.InitRowid+"|"+PathCode
	
	$cm({
		ClassName:"BILL.EINV.BL.COM.InvPageInfoCtl",
		MethodName:"InvocieBill",
		dataStr:dataStr,
		Index:InvRecIndex
	},function(data){
		if(data.status>=0){
			$('#tBillIUD').datagrid('updateRow',{
				index:data.DataIndex,
				row:data.TradeData
			});	
		}else{
			ErrMsgTmp="第["+(InvRecIndex+1)+"]行票据上传失败:"+data.info;
			if(ErrMsg==""){
				ErrMsg=ErrMsgTmp;
			}else{
				ErrMsg=ErrMsg+"\n"+ErrMsgTmp;
			}
		}
		$('#IUDUpload').attr("disabled",false)    //解除禁用
		NextIndex=i+1;    //下一个条记录
		if(NextIndex<AllRecLen){
			InvoiceDo(CheckedRecs, NextIndex, ErrMsg, PathCode)
		}else{
			if(ErrMsg!=""){
				alert(ErrMsg);
			}else{
				alert("补上传成功!");
			}
		}
		
	});
}



///票据撤销（冲红第三方开票数据，HIS不需要退费）
function InvCancel()
{
  var PathCode="InvalidInvSvr" ;
  $.messager.confirm("确认", "是否撤销发票?", function (r) {
				if (r) {
				   Invoice(PathCode);
				}
  });
 	
	
}


/*
//打印调用税控第三方控件打印的放开
//加载第三方税控打印参数设置，sInputInfo目前写死，后续有变动修改
function SetParameter(){
		var sInputInfo = "<?xml version=\"1.0\" encoding=\"gbk\"?>\r\n<business id=\"20001\" comment=\"参数设置\">\r\n<body yylxdm=\"1\">\r\n<servletip>10.30.2.172</servletip>\r\n<servletport>8080</servletport>\r\n<keypwd>88888888</keypwd>\r\n</body>\r\n</business>";
		try
		    {
		ret = sk.Operate(sInputInfo);
		//alert(ret);
		    }
		catch(e)
		    {
		alert(e.message + ",errno:" + e.number);
		    }	
}

///票据打印OCX
function InvPrintOCX()
{
 //alert("打印纸质票据");
 var row = $('#tBillIUD').datagrid('getSelected');
	if(row==null){
		alert("请选择一条记录后再申请开票!");
		return ;
	}
	var prtRowIdStr=row.Invprtrowid+"#"+"R";
	
	oppatInvPrintOCX(prtRowIdStr)   //  打印发票OCX
		
}

*/

function InvPrintOCX()
{
	var row = $('#tBillIUD').datagrid('getSelected');
	if(row==null){
		alert("请选择一条记录后再申请开票!");
		return ;
	}
	
	var LocgicType=row.LocgicType
	if((LocgicType=="REG")||(LocgicType=="OP")){
		var moduleId="140601"			//电子票据种类代码？？？根据项目实际修改代码，字典里面取配置？？
	}
	else if(LocgicType=="IP"){
		var moduleId="140602"
	}
	
	var billBatchCode=row.EInvCode;
	var billNo=row.EInvSeriNo;
	var random=row.EInvRandom;
	
	//var moduleId="140402";     //电子票据种类代码
    //alert("打印开始="+billBatchCode+"!"+billNo+"!"+random+"!"+moduleId)
    var param = {
		'billBatchCode':billBatchCode,
		'billNo':billNo,
		'random':random,
		'moduleId':moduleId 
	}
	industry.printElectBill(param, '1.0', false).then(function (data) {
		   alert("data="+data)
           if(data&&data.result!='S0000'){
                alert(data.message)
            }
    console.log("success")
       }).fail(function (data) {
            console.log( data)
        });
}

/// 换开电子票
/// add by xubaobao 2020 09 08 
function ReInvoice()
{
	var row = $('#tBillIUD').datagrid('getSelected');
	if(row==null){
		alert("请选择一条记录后再申请换开电票!");
		return ;
	}
		
	//冲红第三方数据
	var PayAdmType=row.LocgicType;
	var HISPrtRowID=row.Invprtrowid;
	var OrgHISPrtRowID=row.InitRowid;
	var PathCode="InvalidInvSvr";
	var ExpStr="";    
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"InvocieBill",
		PayAdmType:PayAdmType,
		HISPrtRowID:HISPrtRowID,
		OrgHISPrtRowID:OrgHISPrtRowID,
		PathCode:PathCode,
		ExpStr:ExpStr
		},function(rtn){
			if(rtn.split("^")[0] != "0"){
				$.messager.alert("提示","该票据冲红失败,错误原因:"+rtn.split("^")[1]);
			}else{
				InvocieBill(PayAdmType,HISPrtRowID)
			}
	});
}

/// 开电子票
/// add by xubaobao 2020 09 08 
function InvocieBill(PayAdmType,HISPrtRowID){
	
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"InvocieBill",
		PayAdmType:PayAdmType,
		HISPrtRowID:HISPrtRowID,
		OrgHISPrtRowID:"",
		PathCode:"",
		ExpStr:""
	},function(rtn){
		if(rtn.split("^")[0] != "0"){
			$.messager.alert("提示","开电子票失败,错误原因:"+rtn.split("^")[1]);
		}else{
			$.messager.alert("提示","电子票换开成功");
		}
	});
	
}

// add by xubaobao 2020 05 27
// 打印多张发票
function EInvPrintAll()
{
	var rows = $('#tBillIUD').datagrid('getChecked');
	if(rows.length>0){
		var PathCodeTmp="";
		var ErrMsgTmp="";
		EInvPrintDo(rows, 0, ErrMsgTmp, PathCodeTmp);   //逐个打印
	}else{
		alert("请选择一条记录!");
	}
}

/// 功能说明：发票打印
function EInvPrintDo(CheckedRecs, i, ErrMsg, PathCode){
	
	var ErrMsgTmp="";
	var NextIndex=0;
	var AllRecLen=CheckedRecs.length;   //本次开票数目
	var nowInvRecInfo=CheckedRecs[i];   //当前票据记录
	var InvRecIndex=$('#tBillIUD').datagrid('getRowIndex', nowInvRecInfo);   //当前票据所在行索引
	var LocgicType=nowInvRecInfo.LocgicType
	var billBatchCode=nowInvRecInfo.EInvCode;
	var billNo=nowInvRecInfo.EInvSeriNo;
	var random=nowInvRecInfo.EInvRandom;
	var HISPrtRowID=nowInvRecInfo.Invprtrowid;
	var PDFUrl=nowInvRecInfo.PDFUrl;
	//1.未开具电子发票不允许打印
	if(nowInvRecInfo.EInvFlg!="1")
	{
		alert("未开具电子发票不允许打印电子发票！");
		return ;
	}
	if((billBatchCode=="")||(billNo==""))
	{
		alert("打印电子发票,票据代码、票据号码不能为空");
		return ;
	}
	////2.增加配置，负票是否打印电子发票，默认不打印 add 2022-06-21
	var rtn=$m({
				ClassName:"BILL.EINV.BL.COM.InvPageInfoCtl",
				MethodName:"GetInvInfoByIDAndType",
				PayAdmType:LocgicType,
				HISPrtRowID:HISPrtRowID
	},false);
	if(rtn.split("&")[4]!="N"){
		alert("非正常结算票据，不允许打印!")
		return ;
	}
	///打印次数控制  add 2022-04-08
	$m({
		ClassName:"BILL.EINV.COM.Common",
		MethodName:"GetEINVDicByCodeAndInd",
		DicType:"Einv_ProCode_Case",
		DicCode:"Print_Num_Config",                     
		ind:"5"
	},function(rtn){                      
		///获取当前已经打印次数
		var PrintNum=GetPrintNum(billBatchCode,billNo)
		if((PrintNum>=rtn)&&(rtn!=0)){
			alert("打印次数已经超过设置打印次数，不允许打印!")
			return ;
			}
		
	});
	////????做一个配置,博思现在支持(两种打印，1-JS打印，2-插件打印)
	///w ##class(BILL.EINV.BL.EInvoiceLogic).PrintElectBilllList("IP","23682")
	///##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","FeeItmCateBS_ConFlag",5)
	
	$m({
		ClassName:"BILL.EINV.COM.Common",
		MethodName:"GetEINVDicByCodeAndInd",
		DicType:"Einv_ProCode_Case",
		DicCode:"PrintBS_Config",                     
		ind:"5"
	},function(rtn){                      //0调用JS打印，1,调用exe打印,2调用其他厂家打印-PDF打印
		if((rtn== "1")){
			///调用exe打印  --博思
			PrintByBSExeNew(billBatchCode,billNo,random)
		}else if(rtn== "0"){
			//调用JS方式打印   --博思
			PrintByBSJS(LocgicType,billBatchCode,billNo,random)
			//PrintByBSExe(LocgicType,HISPrtRowID);
		}else if(rtn== "2"){
			//其他打印  PDF打印
		    PrintPDFUrl(PDFUrl)
		}
	});
	NextIndex=i+1;    //下一个条记录
	if(NextIndex<AllRecLen){
		EInvPrintDo(CheckedRecs, NextIndex, ErrMsg, PathCode)
	}		
}

////功能：通过博思JS打印
///input： LocgicType     --业务类型（REG，OP，IP...）
///        billBatchCode  --票据代码
///        billNo         --票据号码
///        random         --票据校验码
function PrintByBSJS(LocgicType,billBatchCode,billNo,random)
{
	var billCode=$.m({
		ClassName:"BILL.EINV.COM.Common",
		MethodName:"GetEINVDicByCodeAndInd",
		DicType:"BusinessTypeConBillCode",
		DicCode:LocgicType, 
		ind:"5"});
	if((LocgicType=="REG")||(LocgicType=="OP")){
		var moduleId=billCode  ;"140601"			//电子票据种类代码  ？？？？通过配置取
	}
	else if(LocgicType=="IP"){
		var moduleId=billCode  ;"140602"
	}
	var param = {
		'billBatchCode':billBatchCode,
		'billNo':billNo,
		'random':random,
		'moduleId':moduleId 
	}
	industry.printElectBill(param, '1.0', false).then(function (data) {
           if(data&&data.result!='S0000'){
                alert(data.message)
           }
   		   console.log("success")
      	   }).fail(function (data) {
            console.log( data)
    });
    ///保存打印次数
    SavePrintNum(billBatchCode,billNo,UserID)
}

///通过博思插件exe打印
/// LocgicType       --业务类型
/// PrtRowid         --发票ID
function PrintByBSExe(LocgicType,PrtRowid){
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"PrintElectBill",
		PayAdmType:LocgicType,
		HISPrtRowID:PrtRowid,                     
	},function(rtn){                      
		if(rtn!= "-1"){
			HttpGet(rtn)
		}	
	});
}

///通过博思插件exe打印
/// billBatchCode  --票据代码
/// billNo         --票据号码
/// random         --校验码
function PrintByBSExeNew(billBatchCode,billNo,random){
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"PrintElectBillNew",
		BillBatchCode:billBatchCode,
		BillNo:billNo,
		Random:random                  
	},function(rtn){                      
		if(rtn!= "-1"){
		   HttpGet(rtn)
           ///保存打印次数
           SavePrintNum(billBatchCode,billNo,UserID)
		}	
	});
}

///通过博思插件exe打印
/// LocgicType       --业务类型
/// PrtRowid         --发票ID
function PrintDetailsByBSExe(LocgicType,PrtRowid){
	$m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"PrintElectBilllList",
		PayAdmType:LocgicType,
		HISPrtRowID:PrtRowid,                     
	},function(rtn){                      
		if (rtn!="-1"){
			HttpGet(rtn)	
			}
		
	});
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#readCard").hasClass("l-btn-disabled")) {
		return;
	}
	try {
		
		//var cardType = getValueById("cardType");
		var cardType= $('#cardType').combobox("getValue");
		var cardTypeDR = cardType.split("^")[0];
		var myRtn = "";
		if (cardTypeDR == "") {
			myRtn = DHCACC_GetAccInfo();
		} else {
			myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
		}
		var myAry = myRtn.toString().split("^");
		var rtn = myAry[0];
		switch (rtn) {
		case "0":
			//setValueById("cardNo", myAry[1]);
			$('#cardNo').val(myAry[1])
			//setValueById("rmarkNo", myAry[5]);
			$('#rmarkNo').val(myAry[5])
			queryBillIUDInfo();
			break;
		case "-200":
			$.messager.alert("提示", "卡无效", "info", function () {
				focusById("readCard");
			});
			break;
		case "-201":
			//setValueById("cardNo", myAry[1]);
			$('#cardNo').val(myAry[1])
			//setValueById("rmarkNo", myAry[5]);
			$('#rmarkNo').val(myAry[5])
			break;
		default:
		}
	} catch (e) {
	}
}
///打印电子发票明细
function InvEPrintDetails(){
	var rows = $('#tBillIUD').datagrid('getChecked');
	if(rows==null){
		alert("请选择一条记录后打印!");
		return ;
	}
	//alert(rows[0].LocgicType+"&"+rows[0].Invprtrowid)
	
	var PayAdmType=rows[0].LocgicType
	var HISPrtRowID=rows[0].Invprtrowid	
	PrintDetailsByBSExe(PayAdmType,HISPrtRowID)
		
}

function printElectBillListSet(billBatchCode,billNo,random,PageNum) {
	var InputPam=billBatchCode+"^"+billNo+"^"+random;
	var PageNum="0"
	$.m({
		ClassName:"BILL.EINV.BL.EInvoiceLogic",
		MethodName:"GetElectBilllListTotal",
		InputPam:InputPam
		},function(rtn){
        if (rtn!="0")
        {   
        //alert("PageNum:"+rtn)
        	PageNum=rtn;
        	
	    }else 
	    {
		   $.messager.show({title:'提示',msg:'获取电子票据明细总页数失败！',timeout:1000,showType:'slide'});
		}
	});	
	
	var param = {
    	'billBatchCode': billBatchCode,
        'billNo': billNo,
        'random': random,
        'total': PageNum,
        'pageNoBgn':1,
        'pageNoEnd':PageNum
    }
    industry.printElectBillList(param, '1.0', false).then(function (data) {
        if(data&&data.result!='S0000'){
           alert(data.message)
        }
        console.log("success")
        }).fail(function (data) {
            console.log( data)
        });
}

function findPatKeyDowncardNo(e){
	var key = websys_getKey(e);
	if (key == 13) {
		GetRegNoByCardNo();
	}
}

function GetRegNoByCardNo(){
	var CardNo=$('#cardNo').val();
	$.m({
		ClassName:"BILL.EINV.COM.Common",
		MethodName:"GetRegNoByCardNo",
		CardNo:CardNo
		},function(rtn){
       		$('#rmarkNo').val(rtn);
       		if(rtn!=""){
				queryBillIUDInfo();
       		}
	});	
}

function HttpGet(URL)
{
	try{
	   var httpRequest; 
       if(window.XMLHttpRequest){    
          httpRequest=new XMLHttpRequest();  // 非IE浏览器，用xmlhttprequest对象创建
       }else if(window.ActiveXObject){    
          httpRequest=new ActiveXObject("Microsoft.XMLHTTP");  // IE浏览器用activexobject对象创建
       }
	   //var httpRequest = new XMLHttpRequest();//第一步：建立所需的对象
        httpRequest.open('GET', URL, true);//第二步：打开连接  将请求参数写在url中  ps:"./Ptest.php?name=test&nameone=testone"
        httpRequest.send();//第三步：发送请求  将请求参数写在URL中
        httpRequest.onreadystatechange = function () {
            if (httpRequest.readyState == 4 && httpRequest.status == 200) {
               var jsonData = httpRequest.responseText;//获取到服务端返回的数据
               //var JsonObj=jsonData.parseJSON();
               var JsonObj=JSON.parse(jsonData)
               var Database64=JsonObj.data;
               var Data=atob(Database64)     //解析Base64   //中文会出现乱码，此处只用返回Code值
               //var DataObj=Data.parseJSON();
               var DataObj=JSON.parse(Data)
               var result=DataObj.result
               console.log( "result"+result );
               if (result=="S0000"){
	               return 0;
	           }else{
		           return -1;   
		       }
            }else{
	           return -1; 
	        }
        }; 
	}catch (e){
		alert("发生异常"+e.message)
	}

}

///保存打印次数
function SavePrintNum(IUDBillBatchCode,IUDBillBatchNo,UserId)
{
	$.m({
		ClassName:"BILL.EINV.BL.COM.InvUpDetailsCtl",
		MethodName:"UPDatePrintNumByEinvCode",
		IUDBillBatchCode:IUDBillBatchCode,
		IUDBillBatchNo:IUDBillBatchNo,
		UserId:UserId
		},function(rtn){
       		if(rtn.split("^")[0]!="0"){
				$.messager.show({title:'提示',msg:rtn.split("^")[1],timeout:1000,showType:'slide'});
       		}
	   });	
}

///获取打印次数
///w ##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetPrintNumByEinvCode("123","456")
function GetPrintNum(IUDBillBatchCode,IUDBillBatchNo)  
{
	var PrintNumStr=$.m({
		              ClassName:"BILL.EINV.BL.COM.InvUpDetailsCtl",
		              MethodName:"GetPrintNumByEinvCode",
		              IUDBillBatchCode:IUDBillBatchCode,
		              IUDBillBatchNo:IUDBillBatchNo
	    });
	   if (PrintNumStr.split("^")[0]>=0)
	   {
		   return PrintNumStr.split("^")[0];
	   }else{
		   
           return 0
	   }	
}

function printEInv(url){
	//window.open(url);
	var objShell=new ActiveXObject("WScript.Shell");
	objShell.Run("cmd.exe /c start chrome "+url,0,true);
}

///打印小条
///打印小条
function PrintDirectInfo()
{
	var row = $('#tBillIUD').datagrid('getSelected');
	if(row==null){
		alert("请选择一条记录后打印小条!");
		return ;
	}
	var billBatchCode=row.EInvCode;
	var billNo=row.EInvSeriNo;
	var random=row.EInvRandom;
	var LocgicType=row.LocgicType
	var HISPrtRowID=row.Invprtrowid;
	
	//门诊，挂号
	if((LocgicType=="OP")||(LocgicType=="REG")||(LocgicType=="IP")){
	      InvPrintDirect(LocgicType,HISPrtRowID)
	//体检	
	}else if(LocgicType=="PE"){
		
		
	}
	
	
	
}

///通过CLODOP打印第三方返回的PDFURL
///使用以下方法需要检查
///     1.确保csp里面的CLODOP已经引用--do ##class(web.DHCXMLPConfig).LODOPInit(1) 
///     2.确保系统包含CLODOP，4.0以上版本
function PrintPDFUrl(PDFUrl)
{
	var LODOP=getLodop();
	if(LODOP){
		LODOP.PRINT_INIT(""); /*清除上次打印元素*/
		/*
		1---纵(正)向打印，固定纸张； 
        2---横向打印，固定纸张；  
        3---纵(正)向打印，宽度固定，高度按打印内容的高度自适应；
        0(或其它)----打印方向由操作者自行选择或按打印机缺省设置；
		*/
		LODOP.SET_PRINT_PAGESIZE(2,0,0,"A4")  //
		LODOP.ADD_PRINT_PDF(0,0,"100%","100%",PDFUrl)
		LODOP.PREVIEW();  //预览打印
		//LODOP.PRINT();    //直接打印
		
	}
	
}


