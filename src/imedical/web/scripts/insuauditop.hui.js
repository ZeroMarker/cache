/**
 * 门诊医保医嘱审核JS
 * FileName:insuauditop.hui.js
 * DingSH 2020-03-04
 * 版本：V1.0
 * hisui版本:0.1.0
 */
var HospDr=session['LOGON.HOSPID'];
var GUser=session['LOGON.USERID'];
var GUserName=session['LOGON.USERNAME'];
var SelPatName="";
var SelBillDr="" ;
var SelOeOrdDr="" ;
var DiagCode="";
var DiagDesc="" 
$(function()
{
 $(document).keydown( 
   function (e){
       //banBackSpace(e);
    });
 //#1初始化需审核患者gd
 InitPatDg()
    
 //#2初始化需审核医嘱项目gd
 InitPatOrdDg()

 //#3初始化Btn事件
 InitBtnClick();   
 
 //#4 初始化病种信息
 InitDiagDesc();
 
 //#5 设置默认日期
 setDefDateValue();
 $("#BtnResume").linkbutton('disable');	
 $HUI.checkbox("#CheckAuditType",{
	onCheckChange:function(e,value){
		if(value) {
			$("#BtnResume").linkbutton('enable');	
			$("#BtnAudit").linkbutton('disable');	
			QryOPChkPatInfo();
		}else{
			$("#BtnResume").linkbutton('disable');	
			$("#BtnAudit").linkbutton('enable');	
			QryOPChkPatInfo();
		}
	}	 
 })
});

/**
* 日期默认设置
*/
function setDefDateValue() {
	var curDateTime =$.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "FormDateTime"}, false);
	var myAry = curDateTime.split(/\s+/);
	setValueById("stDate", myAry[0]); 
	setValueById("edDate", myAry[0]);
}

//初始化Btn事件
function InitBtnClick(){
   //登记号回车
   $("#regNo").keydown( function(e){ 
      RegNo_onkeydown(e);
   }); 
   //病案号回车
   $("#medicareNo").keydown( function(e){ 
      MedicareNo_onkeydown(e);
   }); 
    //个人编号回车
   $("#InsuNo").keydown( function(e){ 
      InsuNo_onkeydown(e);
   }); 
   
  //医保审核     
   $HUI.linkbutton('#BtnAudit',{
      onClick: function()
           {
              Audit_click();
            }
       });
   //医保拒绝   
   $HUI.linkbutton('#BtnRefuse',{
           onClick: function()
           {
             Refuse_click();
            }
       });

   //撤销医保审核  
   $HUI.linkbutton('#BtnResume',{
           onClick: function()
           {
              Resume_click();
           }
       });    
       
    //医保公告信息     
   $HUI.linkbutton('#btnInsuNotice',
    {
       onClick: function()
            {
              InsuNotice_click();
            }
     });      
 
   //申报上报     
   $HUI.linkbutton('#Report ',
    {
       onClick: function()
            {
              Report_click();
            }
     });    
       
  //审批类型
   $HUI.combobox("#RType",{
      onSelect: function(rec)
      {
	     QryOPChkPatInfo() ;  
	   }
   });
   
    //价钱
   $HUI.combobox("#Price800",{
      onSelect: function(rec)
      {
	     QryOPChkPatInfo() ;  
	   }
   });
  
   }

//初始化需审患者信息gd
function InitPatDg()
{
   //初始化datagrid
   $HUI.datagrid("#chkoppatdg",{
	   fit: true,
       //url:$URL,
       selectOnCheck:true,
	   checkOnSelect:true,
       border:false,
       data: [],
        frozenColumns:
       [[ 
          {field:'ordck',title:'ck',width:30,checkbox:true}
         
          ]],
       columns:[[
           {field:'TabRegNo',title:'登记号',width:140},
           {field:'TabPatName',title:'姓名',width:100},
           {field:'TabCTDesc',title:'科室描述',width:150},
           {field:'TabPatType',title:'病人类型',width:100},
           {field:'TabDiagDesc',title:'疾病名称',width:140,showTip:true},
           {field:'TabPrescNo',title:'处方号',width:60},
           {field:'TabOEORIDate',title:'开医嘱日期',width:160},
           {field:'TabOEORITimeOrd',title:'开医嘱时间',width:120},
           {field:'TabOEORIDoctorDesc',title:'开医嘱医生',width:120},
           {field:'TabAuditFlag',title:'审核标记',width:90},
           {field:'Select',title:'选择',width:60,hidden:true},
               {field:'TabPrescPrice',title:'单价',width:90,align:'right',
             formatter:function(val,rowData,rowIndex){
               if(!isNaN(val))
                return Number(val).toFixed(4);
                }
           },
            {field:'TabPackUOM',title:'单位',width:60},
            {field:'TabOEORIPhQty',title:'数量',width:60,align:'right'},
            {field:'TabTotalAmount',title:'金额',width:60,align:'right',
             formatter:function(val,rowData,rowIndex){
               if(!isNaN(val))
                return Number(val).toFixed(2);
                }
            },
             {field:'TabArcimDesc',title:'医嘱名称',width:180},
            {field:'TabPhcfrCode',title:'频次',width:60},
            {field:'TabDoseQtyUnit',title:'剂量',width:60},
            {field:'TabPhOrdQtyUnit',title:'总量',width:60},
            {field:'TabPackNum',title:'整包数量',width:90,hidden:true},
            {field:'TabOEORIRowId',title:'TabOEORIRowId',width:60},
           {field:'TabAuditUserName',title:'审核人',width:80},
           {field:'TabAuditDate',title:'审核日期',width:90},
           {field:'TabAuditTime',title:'审核时间',width:80},
           {field:'TabPatNo',title:'医保号',width:60},
           {field:'TabPatID',title:'身份证号',width:80},
           {field:'job',title:'进程号',width:60},
           {field:'TblRType',title:'审批类型',width:60},
           {field:'TabAdmRowid',title:'TabAdmRowid',width:40,hidden:true},
            {field:'TabDemo',title:'备注 ',width:100,
            editor:{
                       type:'text',
                   }}
           
       ]],
       pageSize: 10,
       pagination:true,
       //onClickRow : function(rowIndex, rowData) {
	       
	    onSelect:function(rowIndex, rowData){
		    setEprMenuForm(rowData.TabAdmRowid); // + DingSH 20220126 
            SelOeOrdDr=rowData.TabOEORIRowId;
            SelPatName=rowData.TabPatName
            QryPatOrd();
           
	       if(rowData.TabAuditFlag=="")
           {
	           
	           disableById('btnSave')
	           disableById('btnAudit')
	           enableById('btnAuditSt')
	       }
	       if(rowData.TabAuditFlag=="完成")
           {
	           
	           disableById('btnSave')
	           disableById('btnAuditSt')
	           disableById('btnAudit')
	           QryPatOrd();
	       }
	        
	       
       },
      onUnselect:function(rowIndex, rowData){
	      SelOeOrdDr="";
          SelPatName="";
	       QryPatOrd();
	      },
       onLoadSuccess:function(data)
       {
           //alert(256)
           SelPatRowObj=null;
           SelPatName=""
           QryPatOrd()
       }
   });
   
}

//初始化需审核患者医嘱gd
function InitPatOrdDg()
{
    //初始化datagrid
   $HUI.datagrid("#chkoppatorddg",{
	   fit: true,
       //url:$URL,
       width: '100%',
       singleSelect:false,
       rownumbers:true,
       selectOnCheck:true,
	   checkOnSelect:false,
       border:false,
       pageSize: 9999,
       pageList: [9999],
       pagination:true,
       data: [],
       frozenColumns:
       [[
          {field:'ck',title:'ck',width:30,checkbox:true}
         
          ]],
       columns:[[
           {field:'TariDr',title:'收费项目指针',width:140},
           {field:'TOEORI',title:'TOEORI',width:10,hidden:true},
           {field:'Tchangeflag',title:'Tchangeflag',width:10,hidden:true},
           {field:'TariCode',title:'收费项目编码',width:200},
           {field:'TariDesc',title:'收费项目名称',width:240 },
           {field:'InsuCode',title:'医保项目编码',width:220},
           {field:'InsuDesc',title:'医保项目名称',width:260 },
           {field:'xmlbDesc',title:'项目类别',width:80},
           {field:'xmlb',title:'项目类别',width:10,hidden:true},
           {field:'Price',title:'单价',width:100,align:'right',
             formatter:function(val,rowData,rowIndex){
               if(!isNaN(val))
                return Number(val).toFixed(4);
                }
           },
           {field:'uomDesc',title:'单位',width:60},
           {field:'sl',title:'数量',width:100,align:'right'},
           {field:'Amount',title:'金额',width:120,align:'right',
             formatter:function(val,rowData,rowIndex){
               if(!isNaN(val))
                return Number(val).toFixed(2);
                }
           }
       ]],
       onClickRow : function(rowIndex, rowData) {
          
       },
       onLoadSuccess:function(data)
       {
          
       }
   });
}
//初始化病种信息
function InitDiagDesc()
{
	$HUI.combogrid('#DiagDesc',{
		 url:$URL,
		 delay: 300,
		 mode: 'remote',
		 method: 'GET',
		 panelWidth:360,
		 idField:'code',
		 textField:'desc',
		 columns:[[
		 {field:'desc',title:'描述',width:200},
		 {field:'code',title:'编码',width:150}
		 ]],
		 onBeforeLoad:function(param){
			param.ClassName="web.DHCMRDiagnos" ;
	    	param.QueryName="LookUpWithAlias" ;
	    	param.desc = param.q ;
		    param.loc = "" ;
		    param.ver1="" ;
		    param.EpisodeID="" ;
		    param.ICDType="" ;
		    
		},
		onSelect:function(index,row){
			DiagCode=row.code;
			DiagDesc=row.desc;
			}
		 
		});
}


//查询审核患者信息
function QryOPChkPatInfo()
{
   SelAdmDr="",SelBillDr=""
   var stDate=getValueById('stDate')
   var edDate=getValueById('edDate')
   var CheckAuditType=getValueById('CheckAuditType')
   if(CheckAuditType){CheckAuditType="on" ;}
   else{CheckAuditType="" ;}
   var RType=getValueById('RType')
   var regNo=getValueById('regNo')
   var tmpRegNo=regNo;
	if (tmpRegNo!="")
		{
	    var regNoLength=10-regNo.length;     //登记号补零   	
		for (var i=0;i<regNoLength;i++){
			tmpRegNo="0"+tmpRegNo;			
		}
		}
	regNo=tmpRegNo;	
    setValueById('regNo',regNo)              //登记号补全后回写
   var Price800=getValueById('Price800')
  
   $('#chkoppatdg').datagrid('options').url=$URL
   $('#chkoppatdg').datagrid('reload',{
       ClassName:'web.INSUAuditOP',
       QueryName:'OPAuditApp',
       RegNo:regNo,
       StartDate:stDate,
       EndDate:edDate,
       CheckAuditType:CheckAuditType,
       RType:RType,
       Price800:Price800,
       HospDr:HospDr
       });
       
       
}
//查询患者医嘱项目明细
function QryPatOrd()
{    
     $('#chkoppatorddg').datagrid('options').url=$URL;
     $('#chkoppatorddg').datagrid('reload',{
       ClassName:'web.INSUAuditOP',
       QueryName:'QueryTariByOrd',
       OeOrdDr:SelOeOrdDr,
       ExpStr:"",
       
       });
   
}



//获取待审核医嘱串
function GetOEORIRowIdStr()
{
	
	 var SelRows=$HUI.datagrid('#chkoppatdg').getChecked();
	 var OEORIRowIdStr=""
      $.each(SelRows, function (index, row) {
	      
			var rowInString="",Insuflag="",Price="",Qty="",Amount="",orderRowid="",TarDr="",BZ="",ListFlag="";
			Insuflag=row.TInsuFlag; //调整自费标志
			
		    if(OEORIRowIdStr==""){
			    OEORIRowIdStr=row.TabOEORIRowId
			    }
		    else{
			    OEORIRowIdStr=OEORIRowIdStr+"^"+row.TabOEORIRowId
			    }
			
		});
		
	return OEORIRowIdStr

}


//医保审核
function Audit_click()
{
   
   	var TabOEORIRowIdStr=GetOEORIRowIdStr()
	if (""==TabOEORIRowIdStr)
	{
		 $.messager.alert('提示', '请选择待审核医嘱', 'info');
		 return ;
	}
    $.m({
            ClassName: "web.INSUAuditOP",
            MethodName: "MedAudit",
            TabOEORIRowIdStr: TabOEORIRowIdStr,
            State:"Y",
            Guser:GUser
        }, function (rtn) {
            if (rtn == 0) {
              $.messager.alert('提示', '审核成功', 'success');
               QryOPChkPatInfo() ; 
               SelOeOrdDr="";
               QryPatOrd();
            } else {
                $.messager.alert('提示', '审核失败,Error=' + rtn, 'error');
            }
        });
        
   
    return ;
        

}

//医保撤销审核
function Resume_click()
{
	var TabOEORIRowIdStr=GetOEORIRowIdStr();
	if (""==TabOEORIRowIdStr)
	{
		 $.messager.alert('提示', '请选择要撤销审核医嘱', 'info');
		 return ;
	}
    $.m({
            ClassName: "web.INSUAuditOP",
            MethodName: "MedAudit",
            TabOEORIRowIdStr: TabOEORIRowIdStr,
            State:"",
            Guser:GUser
        }, function (rtn) {
            if (rtn == 0) {
              $.messager.alert('提示', '更新成功', 'success');
               QryOPChkPatInfo() ; 
               SelOeOrdDr="";
               QryPatOrd();
            } else {
                $.messager.alert('提示', '更新失败,Error=' + rtn, 'error');
            }
        });
        
}

//医保拒绝
function Refuse_click()
{
	var TabOEORIRowIdStr=GetOEORIRowIdStr();
	if (""==TabOEORIRowIdStr)
	{
		 $.messager.alert('提示', '请选择要审核拒绝医嘱', 'info');
		 return ;
	}
    $.m({
            ClassName: "web.INSUAuditOP",
            MethodName: "MedAudit",
            TabOEORIRowIdStr: TabOEORIRowIdStr,
            State:"N",
            Guser:GUser
        }, function (rtn) {
            if (rtn == 0) {
              $.messager.alert('提示', '更新成功' , 'success');
               QryOPChkPatInfo() ; 
               SelOeOrdDr="";
               QryPatOrd();
            } else {
                $.messager.alert('提示', '更新失败,Error=' + rtn, 'error');
            }
        });
}

//医保公告
function InsuNotice_click()
{
    //InsuNotice(Guser,NowDate); //DHCINSUPort.js 此功能暂未纳入标准版
     $.messager.alert('提示', '此接口需要连接医保中心,暂无此功能', 'info');
}


//组织申报参数串
function BuildReportStr(row){
	
	            var TariCode=row.TariCode; 
  				var TariDesc=row.TariDesc; 
  				var InsuCode=row.InsuCode; 
  				var InsuDesc=row.InsuDesc; 
  				InsuDesc=InsuDesc.replace("","").replace("","")
  				var xmlb=row.xmlb; 
  				var sl=row.sl; 
  				var Price=row.Price; 
  				var Amount=row.Amount;
  				var SDate=row.SDate;
	            var EDate=row.EDate;
	            var ZZ=row.ZZ;
	            var MD=row.MD;
	            var InsuNo=row.InsuNo;
	            var States=row.States;
	            var RptType=row.RptType;
  				if (RptType=="41") {Amount=Price;}	
				//var str=InsuNo+"|"+RptType+"|"+AdmSeriNo+"|"+OutHosName+"|"+HosLevel+"|"+DiagCode+"|"+DiagDesc+"|"+HosYJ+"|"+xmbm+"|"+xmmc+"|"+sl+"|"+RptDate+"|"+SDate+"|"+EDate+"|"+GuserName+"|"+OutType+"|"+Demo+"|"+money+"|"+xmlb+"|"+RPTNo+"|"+ZYZZ+"|"+MD+"|"+Doctor+"|"+KZR+"|"+JSYJ+"|"+KZRYJ+"|"+LRuser+"|"+LRDate+"|"+RPTUser+"|"+HisCode+"|"+HisDesc+"|"+AdmType+"|"+NumberID+"|"+States
				var str=InsuNo+"|"+RptType+"|"+""+"|"+""+"|"+""+"|"+DiagCode+"|"+DiagDesc+"|"+"01"+"|"+InsuCode+"|"+InsuDesc+"|"+sl+"|"+SDate+"|"+SDate+"|"+EDate+"|"+GUserName+"|"+""+"|"+""+"|"+Amount+"|"+xmlb+"|"+""+"|"+ZZ+"|"+MD+"|"+""+"|"+""+"|"+"01"+"|"+"01"+"|"+GUserName+"|"+SDate+"|"+GUserName+"|"+TariCode+"|"+TariDesc+"|"+""+"|"+""+"|"+States

	
	}

//申报上报
function Report_click(){
	 $.messager.alert('提示', '此接口需要连接医保中心,暂无此功能', 'info');
	    var Amount="",flag=0,SDate="",EDate="",SucessCount=0;
	    var Month=now.getMonth()+1;
  		var Date=now.getDate();
  		if (String(Month).length<2)   Month="0"+Month 
  		if (String(Date).length<2)   Date="0"+Date 
   		 SDate=String(Year)+String(Month)+String(Date)
  		 now.setDate(now.getDate()+7)
  		 Year=now.getFullYear();Month=now.getMonth()+1;Date=now.getDate();
  		if (String(Month).length<2)   Month="0"+Month 
  		if (String(Date).length<2)   Date="0"+Date 
		EDate=String(Year)+String(Month)+String(Date)
		now.setDate(now.getDate()-7)
		var ZZ=getValueById('ZZ');  //症状
  		var MD=getValueById('MD');  //目的
  		var InsuNo=getValueById('InsuNo');  //个人编号
  		var States=getValueById('States');  //参保地
  	    if (ZZ=="") {$.messager.alert('提示','请录入症状','info');return;}
  		if (DiagCode=="") {$.messager.alert('提示','请选择病种名称','info');return;}
  		if(States=="") {$.messager.alert('提示','参保地数据错误，请重新录入','info');return;}
  		var RptType=""
	    var SelRows=$HUI.datagrid('#chkoppatorddg').getChecked();
	    var OEORIRowIdStr=""
      $.each(SelRows, function (index, row) {
	      row.SDate=SDate;
	      row.EDate=EDate;
	      row.ZZ=ZZ;
	      row.MD=MD;
	      row.InsuNo=InsuNo;
	      row.States=States
	      row.RptType=RptType;
	      var ReportStr=BuildReportStr(row);
	      var ExpString=SelPatName+"^"+SelOeOrdDr;
		  var rtn=InsuReport(ReportStr,GUser,ExpString); //DHCINSUPort.js
	      	if (rtn==-1){
					 $.messager.alert('提示',"第"+i+"条数据审批上报失败!请检查数据重新上传第"+i+"条数据",'error');
				}
				else
				{
					SucessCount=SucessCount+1	
				}
	      });
	
		 $.messager.alert('提示',"审批上报成功数据"+SucessCount +"条!",'success');
		 return ;

}	

//登记号回车
function RegNo_onkeydown(e)
{
   if (e.keyCode==13)
   {
       QryOPChkPatInfo();
       
   }
}

//病案号回车
function MedicareNo_onkeydown(e)
{
   if (e.keyCode==13)
   {
       QryOPChkPatInfo();
       
   }
}

//个人编号
function InsuNo_onkeydown(e)
{
   if (e.keyCode==13)
   {
       ReadCard_click();
       
   }
}



function ReadCard_click()
{
	
	var CardType="0",InsuNo="",States=""
	var InsuNo=getValueById("InsuNo"); //个人编号
	if ((String(InsuNo).length==15)||(String(InsuNo).length==18)) CardType="1"
    var ExpString="NJB^^"
	var rtn= InsuReadCard(0,GUser,InsuNo,CardType,ExpString); //DHCINSUPort.js
	if(rtn==-1)
	{
	    $.messager.alert('提示', '读卡失败,Error=' + rtn, 'error');
		return;
	}
	var TmpData=str.split("|")
	if (TmpData[0]!="0")  $.messager.alert('提示', '读卡失败,TmpData=' + TmpData, 'error');
 	else 
 	{ ///9037786^10110377^3501-5^杨玉仙^女^^19360914000000^450106360914002^南宁市多丽电器有限责任公司^^^21^^786.51^^^^0^^450100|10015424^^20020515000000^2^1^^^^450107^10^100^3132      ^0^2011^840.8^0^0^0^0^0^0^0^46^1^0
	 	var TmpData1=TmpData[1].split("^")
		setValueById('InsuNo',TmpData1[0]) //个人编号
		CenterNo=TmpData[2].split("^")[8]
		if(SelPatName!=TmpData1[3])
		{
			$.messager.alert('提示',"姓名不一致,医保卡上姓名:"+TmpData1[3],'info');
			disableById('BtnAudit')
			return ;
			
	    }else
	    {
	        enableById('BtnAudit');
		 }
		CenterNo=TmpData[2].split("^")[8]
		/*if (CenterNo=="450122")	States="武鸣县"
		else if (CenterNo=="450123")	States="隆安县"
		else if (CenterNo=="450124")	States="马山县"
		else if (CenterNo=="450125")	States="上林县"
		else if (CenterNo=="450126")	States="横县"  
		else if (CenterNo=="450127")	States="宾阳县"
		else {States="南宁市";CenterNo=="450100";}*/
		setValueById('States',States)
	
	 	}
}

function SetValue(value)
{
   if(value == undefined)
   {
       value="" ;
   }
   
   value=value.toString().replace(/\"/g, "");
   value=value.toString().replace(/\?/g,"");
   return value;
}

 /*头菜单传值*/
function setEprMenuForm(episodeId, patientId) {
	var frm = dhcsys_getmenuform();
	if (frm && (frm.EpisodeID.value != episodeId)) {
		frm.EpisodeID.value = episodeId;
		frm.PatientID.value = patientId;
	}
}
