/**
 * 住院医保医嘱审核JS
 * FileName:insuauditip.hui.js
 * DingSH 2020-02-25
 * 版本：V1.0
 * hisui版本:0.1.0
 */
var HospDr=session['LOGON.HOSPID'];
var GUser=session['LOGON.USERID'];
var GUserName=session['LOGON.USERNAME'];
var SelAdmDr="";
var SelBillDr="" 
var theInterval;
var SelPatModifyAfterRowObj;
var PatOrd={
	  curRow:null,
	  cunIndex:-1
	}
var PatOrdLst={
	  curRow:null,
	  cunIndex:-1
	}
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
 
 //#4隐藏元素
 $('#DiagWin').hide();
 $('#PatOrdLstWin').hide();    
 //$('#stDate').datebox('setValue','08/01/2020');
// $('#edDate').datebox('setValue','08/01/2020');
 //#5日期默认设置
 setDefDateValue();
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


/**
* 取当前时间
*/
function getCurDateTime() {
	return 
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
   
   //开始审核
   $HUI.linkbutton('#btnAuditSt',
   {
     onClick: function()
           {
             btnAuditSt_click();
            }
    });    
  //开始自动查询           
   $HUI.linkbutton('#btnSearchAutoSt',
   {
      onClick: function()
           {
             theInterval=setInterval(QryChkPatInfo,10000);
             $("#btnSearchAutoSt").linkbutton('disable');
            }
    });  
  //停止自动查询     
   $HUI.linkbutton('#btnSearchAutoStp',
    {
       onClick: function()
            {
              clearInterval(theInterval);
              $("#btnSearchAutoSt").linkbutton('enable');
            }
     });     
  //医保完成审核     
   $HUI.linkbutton('#btnAudit',{
      onClick: function()
           {
              Audit_click();
            }
       });
   //保存   
   $HUI.linkbutton('#btnSave',{
           onClick: function()
           {
              btnSave_click() ;
            }
       });

   //重新审核   
   $HUI.linkbutton('#btnAuditReset',{
           onClick: function()
           {
             BtnAuditBack_click();
            }
       });    
  //审核状态
   $HUI.combobox("#chkType",{
      onSelect: function(rec)
      {
	     QryChkPatInfo() ;  
	   }
   });
   
   //查询类型
   $HUI.combobox("#searchType",{
      onSelect: function(rec)
      {
	     QryChkPatInfo() ;  
	   }
   });
   
   
  
   }

//初始化需审患者信息gd
function InitPatDg() {
   //初始化datagrid
   $HUI.datagrid("#chkpatdg",{
	   fit: true,
       url: $URL,
       singleSelect: true,
       border: false,
       data: [],
       columns:[[
           {field:'TabRegNo',title:'登记号',width:120},
           {field:'TabPatName',title:'姓名',width:100},
           {field:'TabCTDesc',title:'病房描述',width:150},
           {field:'TabPatType',title:'病人类型',width:100},
           {field:'TabDiagDesc',title:'诊断',width:160
           ,formatter: function (value, row, index) {
                          if(value!="")
                          {
                           return "<a class='hisui-tooltip' href='#' title='查看诊断详细' onclick='showDiagWin("+JSON.stringify(row)+")' \'>"+value+"</a>";
                          }
                   }
           
           },
           {field:'TabDemo',title:'备注 ',width:100,
            editor:{
                       type:'text',
                   }},
           {field:'TabAuditFlag',title:'审核标记',width:80},
           {field:'TabAuditUserName',title:'审核人',width:120},
           {field:'TabAuditDate',title:'审核日期',width:120},
           {field:'TabAuditTime',title:'审核时间',width:80},
           {field:'TabAdmDate',title:'入院日期',width:100},
           {field:'TabDischgDate',title:'出院日期',width:100},
           {field:'TabPoint',title:'自费比重',width:80},
           {field:'TabTolAmount',title:'总金额',width:100,align:'right'},
           {field:'TabSex',title:'性别',width:60},
           {field:'TMediCare',title:'病案号',width:100},
           {field:'TabBillDr',title:'帐单号',width:100},
           {field:'TabReceiveFlag',title:'接收状态',width:40,hidden:true},
           {field:'TabAdmRowid',title:'TabAdmRowid',width:40,hidden:true},
           
       ]],
       pageSize: 10,
       pagination:true,
       onClickRow : function(rowIndex, rowData) {
	      
	       var ordEditIndex=undefined;
	       OrdEndEditing();
           SelAdmDr=rowData.TabAdmRowid;
           SelBillDr=rowData.TabBillDr
           setEprMenuForm(rowData.TabAdmRowid,""); // + DingSH 20220126 
          var DivFlag=tkMakeServerCall("web.DHCINSUDivideSubCtl","GetDivSubUpConutByBillDr",SelBillDr,"");
	     if (DivFlag>0)
	      {  
	        $.messager.alert('提示', '该患者已经医保费用上传,不能进行费用调整！','info');
	         disableById('btnSave')
	        return;
	      }
           if(rowData.TabAuditFlag=="开始审核")
           {
	           
	           disableById('btnAuditSt')
	           enableById('btnAudit')
	           enableById('btnSave')
	           enableById('btnAuditReset')
	           QryPatOrd();
	       }
	       if(rowData.TabAuditFlag=="")
           {
	           
	           disableById('btnSave')
	           disableById('btnAudit')
	           disableById('btnAuditReset')
	           enableById('btnAuditSt')
	       }
	       if(rowData.TabAuditFlag=="完成")
           {
	           
	           disableById('btnSave')
	           disableById('btnAuditSt')
	           disableById('btnAudit')
	           enableById('btnAuditReset')
	            QryPatOrd();
	       }
	       
	       /*$HUI.datagrid('#chkpatOrddg',{selectOnCheck:false,
	                          checkOnSelect:false,
	                          singleSelect:true
	       })*/
	       
	       
	       
       },
       onClickCell:function(index,field,value){
           onClickCell(index,field);
           
           },
       onLoadSuccess:function(data)
       {
           //alert(256)
           SelPatRowObj=null;
           SelAdmDr=""
           SelBillDr=""
           QryPatOrd()
       }
   });
   
}

//初始化需审核患者医嘱gd
function InitPatOrdDg()
{
    //初始化datagrid
   $HUI.datagrid("#chkpatOrddg",{
	   url: $URL,
	   fit: true,
       singleSelect: false,
       rownumbers: true,
       selectOnCheck: true,
	   checkOnSelect: false,
       border: false,
       pageSize: 99999999,
       pagination:false,
       toolbar: [],
       data: [],
       frozenColumns:
       [[ { 
           field: 'TListFlag',
           width: 40,
           title: '链接',
           align: 'center',
           formatter: function (value, row, index) {
                          if(value!="")
                          {
                            if(HISUIStyleCode == "lite") {
                                return "<p class='icon icon-paper-info' style='width:60' title='查看医嘱详细' onclick='showPatOrdLstWin("+JSON.stringify(row)+")'  style='border:0px;cursor:pointer; \'>";
                            }else{
                                return "<img class='myTooltip' style='width:60' title='查看医嘱详细' onclick='showPatOrdLstWin("+JSON.stringify(row)+")' src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper_info.png' style='border:0px;cursor:pointer; \'>";
                            }                   
                          }
                   }
         },
          {field:'ck',title:'ck',width:10,checkbox:true}
         
         
          ]],
       columns:[[
          
           {field:'TTarDr',title:'TTarDr',width:10,hidden:true},
           {field:'TOEORI',title:'TOEORI',width:10,hidden:true},
           {field:'Tchangeflag',title:'Tchangeflag',width:10,hidden:true},
           {field:'TTarDesc',title:'项目名称',width:180},
           {field:'Txmdj',title:'项目等级',width:100,
            styler:function(value,row,index)
             {
	            if(HISUIStyleCode == "lite") {
                    return 'color:#339EFF' ;
                }else{
                }
	            return 'color:#40A2DE' ;
	            }
           },
           {field:'TPrice',title:'单价',width:80,align:'right',
              formatter:function(val,rowData,rowIndex){
               if(val!=null)
                return Number(val).toFixed(4);
                }
           },
           {field:'TQty',title:'数量',width:80,align:'right'},
           {field:'TAmount',title:'总金额',width:100,align:'right',
	           formatter:function(val,rowData,rowIndex){
               if(val!=null)
                return Number(val).toFixed(2);
                }
            
            },
            {field:'TInsuFlag',title:'调整为自费',width:100,
            formatter:function(val,rowData,rowIndex){
                  return (val=="Y") ? "是" : "否";
                },
             editor:{
	             type:'switchbox',
	             options:{   
		         onClass:'primary',
	             offClass:'gray',
	             onText:'是',
	             offText:'否',
	             onSwitchChange:function(event,obj){
		                RowTInsuFlagOnChange(obj.value,"chkpatOrddg",PatOrd.curIndex,PatOrd.curRow);
		             }
		             }
	             }
           },
            
           {field:'TOrderDate',title:'医嘱日期',width:90},
           {field:'TOrderTime',title:'医嘱时间',width:80},
           {field:'TDocName',title:'医嘱录入人',width:90},
           {field:'Tybbz',title:'限制信息',width:130},
           {field:'TUomDesc',title:'单位',width:60},
           {field:'TDemo',title:'备注',width:100, editor:{
                       type:'text',
                   }},
           {field:'TDHCTarCate',title:'项目分类',width:80},
           {field:'TarInsuFlag',title:'原始等级',width:140},
           {field:'TArcimDesc',title:'医嘱名称',width:140},
           {field:'TInsuTarCode',title:'医保项目编码',width:120},
           {field:'TInsuTarDesc',title:'医保项目名称',width:140},
           {field:'TTarCode',title:'医院项目编码',width:120},
           {field:'MotherAdmFlag',title:'MotherAdmFlag',width:100},
           {field:'TmpOutDrugFlag',title:'TmpOutDrugFlag',width:150},
           
           
       ]],
    
       onClickRow : function(rowIndex, rowData) {
           onClickOrdRow(rowIndex,rowData)
           PatOrd.curRow = rowData;
           PatOrd.curIndex = rowIndex
          RowTInsuFlagCheck('chkpatOrddg',rowIndex, rowData) ;
       },
       onLoadSuccess:function(data)
       {
          
       }
   });
}

//查询审核患者信息
function QryChkPatInfo()
{
   SelAdmDr="",SelBillDr=""
   var stDate=getValueById('stDate')
   var edDate=getValueById('edDate')
   var searchType=getValueById('searchType')
   var chkType=getValueById('chkType')
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
   
   var medicareNo=getValueById('medicareNo')
   $('#chkpatdg').datagrid('reload',{
       ClassName:'web.INSUAuditIP',
       QueryName:'IPAuditApp',
       RegNo:regNo,
       StartDate:stDate,
       EndDate:edDate,
       CheckAuditType:"",
       DepList:"",
       CheckInPat:searchType,
       CheckAuditFlag:chkType,
       ReceiveFlag:"",
       MediCare:medicareNo,
       HospDr:HospDr
       });
       
       EditIndexDefault(); ///
}
//查询患者医嘱项目明细
function QryPatOrd()
{    
     $('#chkpatOrddg').datagrid('reload',{
	
       ClassName:'web.INSUAuditIP',
       QueryName:'IPAuditAppDetail',
       AdmDr:SelAdmDr,
       BillDr:SelBillDr,
       
       });
   
}

//开始审核
function btnAuditSt_click()
{
    //Rowid^Adm_Dr^AdmInfo_Dr^OEORI_Dr^TaritmDr^PBD_Dr^InsuFlag^Scale^UnitPrice^Qty^Amount^AuditInfo^User_Dr^UserName^Date^Time^AuditFlag^BZ^Demo1^Demo2^Demo3^Demo4^Demo5^Demo6^Demo7^Demo8^Demo9^Demo10
    endEditing();
    if(SelPatModifyAfterRowObj==null)
    {
       $.messager.alert('提示', '请选择需审核患者记录', 'info') ;
       return ;
	}
    if(SelAdmDr=="")
    {
       $.messager.alert('提示', '就诊号不能为空，请选择需审核患者记录', 'info') ;
       return ;
    }
    if(SelBillDr=="")
    {
       $.messager.alert('提示', '帐单号不能为空，请选择需审核患者记录', 'info') ;
       return ;
    }
    var BZ=SelPatModifyAfterRowObj.TabDemo
    var AuditUserName=SelPatModifyAfterRowObj.TabAuditUserName
    var TabAuditFlag=SelPatModifyAfterRowObj.TabAuditFlag
	if ((AuditUserName!="")&&(AuditUserName!=GUserName)){
		$.messager.alert('提示', '该患者,已由审核人员['+SelPatModifyAfterRowObj.TabAuditUserName+']在审核<br>审核状态:'+abAuditFlag+',不可重复审核', 'info')
		return;
		}
   	var InString = "^"+SelAdmDr+"^"+SelBillDr+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+0+"^"+0+"^"+0+"^"+0+"^"+GUser+"^"+GUserName+"^^^"+"开始审核"+"^"+BZ+"^^^^^^^^^^^"
	
	 $.m({
            ClassName: "web.INSUAuditIP",
            MethodName: "SaveAuditLog",
            InString: InString,
        }, function (rtn) {
            if (rtn > 0) {
              $.messager.alert('提示', '审核开始', 'success') ;
              QryChkPatInfo() ;  
            } else {
                $.messager.alert('提示', '审核开始失败,Error=' + rtn, 'error') ;
            }
        });
        
    
}

//审核完成
function Audit_click()
{
    endEditing();
    if(SelPatModifyAfterRowObj==null)
    {
      $.messager.alert('提示', '请选择需审核患者记录', 'info') ;
      return ;
	 }
    if(SelAdmDr=="")
    {
      $.messager.alert('提示', '就诊号不能为空，请选择需审核患者记录', 'info') ;
      return ;
    }
    if(SelBillDr=="")
    {
     $.messager.alert('提示', '帐单号不能为空，请选择需审核患者记录', 'info') ;
     return ;
    }
    var BZ=SelPatModifyAfterRowObj.TabDemo ;
	if ((SelPatModifyAfterRowObj.TabAuditUserName!=GUserName))
	{
		$.messager.alert('提示', '该患者已有'+SelPatModifyAfterRowObj.TabAuditUserName+'在审核,不可审核', 'info')
		return ;
	}
		
	//Save_Click();  //完成审核时自动保存 2011 12 26

   	var InString = "^"+SelAdmDr+"^"+SelBillDr+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+0+"^"+0+"^"+0+"^"+0+"^"+GUser+"^"+GUserName+"^^^"+"完成"+"^"+BZ+"^^^^^^^^^^^"
	$.m({
            ClassName: "web.INSUAuditIP",
            MethodName: "SaveAuditLog",
            InString: InString,
        }, function (rtn) {
            if (rtn > 0) {
              $.messager.alert('提示', '完成审核' + rtn, 'success');
               QryChkPatInfo() ; 
            } else {
                $.messager.alert('提示', '完成审核失败,Error=' + rtn, 'error');
            }
        });
        
        
        
}

//重新审核
function BtnAuditBack_click()
{	
	endEditing();
    if(SelPatModifyAfterRowObj==null)
    {
        $.messager.alert('提示', '请选择需审核患者记录', 'info') ;
        return ;
	 }
    if(SelAdmDr=="")
    {
        $.messager.alert('提示', '就诊号不能为空，请选择需审核患者记录', 'info') ;
        return ;
     }
    if(SelBillDr=="")
    {
        $.messager.alert('提示', '帐单号不能为空，请选择需审核患者记录', 'info');
        return ;
    }
    var BZ=SelPatModifyAfterRowObj.TabDemo
	if ((SelPatModifyAfterRowObj.TabAuditUserName!=GUserName))
	{
		$.messager.alert('提示', '该患者已有'+SelPatModifyAfterRowObj.TabAuditUserName+'在审核,不可审核', 'info')
		return;
	 }
     //Rowid^Adm_Dr^AdmInfo_Dr^OEORI_Dr^TaritmDr^PBD_Dr^InsuFlag^Scale^UnitPrice^Qty^Amount^AuditInfo^User_Dr^UserName^Date^Time^AuditFlag^BZ^Demo1^Demo2^Demo3^Demo4^Demo5^Demo6^Demo7^Demo8^Demo9^Demo10
    //var InString = "^"+AdmRowid+"^"+BillDr+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+0+"^"+0+"^"+0+"^"+0+"^"+Guser+"^"+GuserName+"^^^"+"完成"+"^"+BZ+"^^^^^^^^^^^"
   	var InString = "^"+SelAdmDr+"^"+SelBillDr+"^"+""+"^"+""+"^"+""+"^"+""+"^"+""+"^"+0+"^"+0+"^"+0+"^"+0+"^"+GUser+"^"+GUserName+"^^^"+"开始审核"+"^"+BZ+"^^^^^^^^^^^"
	$.m({
            ClassName: "web.INSUAuditIP",
            MethodName: "SaveAuditLog",
            InString: InString,
        }, function (rtn) {
            if (rtn > 0) {
              $.messager.alert('提示', '重新审核开始', 'success');
               QryChkPatInfo() ;
            } else {
                $.messager.alert('提示', '重新审核失败,Error=' + rtn, 'error');
            }
        });
}



//项目调整自费调用函数
function RowTInsuFlagOnChange(val,dgId,index,row){
	var selPatRow=$HUI.datagrid("#chkpatdg").getSelected()
    if (selPatRow.TabAuditFlag!="开始审核"){
	   $.messager.alert('提示', '非开始审核状态,不能调整项目', 'info');
	    return ;
	    }
	 if ((selPatRow.TabAuditUserName!=GUserName))
	{
		$.messager.alert('提示', '该患者已有'+selPatRow.TabAuditUserName+'在审核,不能调整项目', 'info')
		return;
	 }    
     $HUI.datagrid('#'+dgId).checkRow(index);
	  if(undefined==row) return;   
	  var InsuFlag="" ;   
	  var Txmdj=row.Txmdj
		  if(undefined!=Txmdj) {
		      if(val) {
			      InsuFlag="N";
			      if (row.Txmdj.indexOf("-")<0) {
				       Txmdj=row.Txmdj+"->丙类";	
		           }
			      
			   } else  {
				      InsuFlag="Y";
				       Txmdj=Txmdj.split("-")[0] ;
				      
			   }
            }
	  HISUIDataGrid.setFieldValue('Txmdj',Txmdj,index,dgId);
	  var TarDr,OEORIDr
	  if (dgId=='chkpatOrddg')
	   {
	    TarDr=row.TTarDr
	     OEORIDr=""
	   }
	   if (dgId=='patordlstdg')
	   {
	     TarDr=getValueById('lstTarDr')
	     OEORIDr=row.TOEExeDr
	   }
	  SaveInsuFlag(TarDr,OEORIDr,InsuFlag);
	  
	
	  
	  
	}

//调整为自费校验
function RowTInsuFlagCheck(dgId,index,row)
{
	
  var selPatRow=$HUI.datagrid("#chkpatdg").getSelected()
    if (selPatRow.TabAuditFlag!="开始审核"){
	   $.messager.alert('提示', '非开始审核状态,不能调整项目', 'info');
	    return ;
	    }
	 if ((selPatRow.TabAuditUserName!=GUserName))
	{
		$.messager.alert('提示', '该患者已有'+selPatRow.TabAuditUserName+'在审核,不能调整项目', 'info')
		return;
	 }     
	ed= $HUI.datagrid('#'+dgId).getEditor({index: index, field: "TInsuFlag"});
	
	

					
	var ckval=false;
	if (row.TInsuFlag=="Y")
	{
		ckval=true
		
	}
	if (ed) {
		$(ed.target).switchbox('setValue',ckval) ;
	}
	
}

//调整为自费checkbox改变时调用
function SaveInsuFlag(TarDr,OEORIDr,InsuFlag)
{
	
	var BillDr=SelBillDr ;
	$.m(
	  {
		ClassName:'web.INSUAuditIP',
		MethodName:'SaveInsuFlag',
		BillDr:BillDr,
		TarDr:TarDr,
		OEORIDr:OEORIDr,
		InsuFlag:InsuFlag
	  },
	   function(rtn)
	   {
		   // $.messager.alert('提示', '测试,rtn=' + rtn, 'info');
		   
		}
	
	
	);
	
}
//审核保存医嘱项目明细
function btnSave_click()
{

    endEditing();
    if(SelPatModifyAfterRowObj==null)
    {
        $.messager.alert('提示', '请选择需审核患者记录', 'info') ;
        return ;
	 }
    if ((SelPatModifyAfterRowObj.TabAuditFlag!="开始审核"))
     {
		$.messager.alert('提示', "'审核标记' 不是 '开始审核' 状态,不可保存", 'info') ;
		return ;
	 }  
    if(SelAdmDr=="")
    {
        $.messager.alert('提示', '就诊号不能为空，请选择需审核患者记录', 'info') ;
        return
     }
    if(SelBillDr=="")
    {
        $.messager.alert('提示', '帐单号不能为空，请选择需审核患者记录', 'info') ;
        return ;
    }
  
	if ((SelPatModifyAfterRowObj.TabAuditUserName!=GUserName))
	{
		$.messager.alert('提示', '该患者已有'+SelPatModifyAfterRowObj.TabAuditUserName+'在审核,不可审核', 'info')
		return ;
	}    
      OrdEndEditing()
     //s val=##Class(%CSP.Page).Encrypt($lb("")) 
     var SuccNum=0, ErrorNum=0,ErrMsg="" ;
      var SelRows=$HUI.datagrid('#chkpatOrddg').getChecked();
      if (SelRows.length==0){
	      
	      $.messager.alert('提示', '请选择记录,保持复选框勾选', 'info')
		  return ;
	      }
      $.each(SelRows, function (index, row) {
	      
			var rowInString="",Insuflag="",Price="",Qty="",Amount="",orderRowid="",TarDr="",BZ="",ListFlag="";
			Insuflag=row.TInsuFlag; //调整自费标志
			orderRowid=row.TOEORI
			TarDr=row.TTarDr	
            Price=row.TPrice
            Qty=row.TQty
            Amount=row.TAmount
            ListFlag=row.TListFlag
            if(ListFlag=="明细"){orderRowid="";}
            orderRowid="" //如果系统没有执行记录就取消注释 Zhan 20160413
			BZ=row.TDemo
			rowInString="^"+SelAdmDr+"^"+SelBillDr+"^"+orderRowid+"^"+TarDr+"^"+""+"^"+Insuflag+"^"+""+"^"+Price+"^"+Qty+"^"+Amount+"^"+1+"^"+GUser+"^"+GUserName+"^^^^"+BZ+"^^^^^^^^^^^"
			$.m({
                  ClassName: "web.INSUAuditIP",
                  MethodName: "SaveAuditLog",
                  InString: rowInString,
                }, function (rtn) {
                   if (rtn > 0) 
                     {
                        //$.messager.alert('提示', '重新审核开始', 'success');  
                         SuccNum=SuccNum+1       
                     } else 
                      {
                         //$.messager.alert('提示', '重新审核失败,Error=' + rtn, 'error');
                         ErrorNum=ErrorNum+1
                         ErrMsg=ErrMsg+'|收费项目Dr='+TarDr+"保存失败,ErrNo:"+rtn
                       }
                  });
			
		    
		});
		
		$.messager.alert('提示', '保存成功', 'success',function(){
			QryPatOrd();	
		});
		return ;
}

//登记号回车
function RegNo_onkeydown(e)
{
   if (e.keyCode==13)
   {
       QryChkPatInfo();
       
   }
}

//病案号回车
function MedicareNo_onkeydown(e)
{
   if (e.keyCode==13)
   {
       QryChkPatInfo();
       
   }
}

//诊断信息列表展示
function showDiagWin(rowData)
{       
   
   InitPatDiagDg(rowData)
   $('#DiagWin').show(); 
       $HUI.dialog("#DiagWin",{
           title:"诊断详细信息",
           height:300,
           width:640,
           //collapsible:true,
           modal:true,
           iconCls: 'icon-w-list'
  
       })
   
}
//初始化诊断gd
function InitPatDiagDg(rowData)
{
   //初始化datagrid
   $HUI.datagrid("#patdiagdg",{
       url:$URL+'?ClassName='+"web.DHCINSUPortUse"+'&QueryName='+"GetDiagnosInfo"+"&AdmDr="+rowData.TabAdmRowid,
       width: '100%',
       border: false ,
       singleSelect: true,
       columns:[[
           {field:'DiagnosNum',title:'序号',width:80},
           {field:'ICDCode',title:'ICD诊断',width:103},
           {field:'SDSDesc',title:'诊断信息',width:230},
           {field:'DiagnosPrefix',title:'诊断前缀',width:80},
           {field:'MedicalRecord',title:'诊断备注',width:80},
          {field:'MainDiagFlag',title:'主诊断',width:60,
	            formatter: function(value,row,index)
	                {
			              return  value=="Y" ? "是":"否" 
			        }
			   },    
	        {field:'DiagnosType',title:'诊断类型',width:80},   
          
       ]],
       pageSize: 10,
       pagination:true,
       onBeforeLoad:function(param){
			//param.ClassName='web.INSUAuditIP';
			//param.QueryName='GetDiagnosInfo';
			//param.AdmDr=SelAdmDr;
			
		},		
       onLoadSuccess:function(data)
       {
          
       }
       
   });
   
}

//医嘱详细息列表展示+操作
function showPatOrdLstWin(rowData)
{
	
  InitPatOrdLstDg(rowData)
   $('#PatOrdLstWin').show(); 
       $HUI.dialog("#PatOrdLstWin",{
           title:"医嘱详细信息",
           height:400,
           width:900,
           //collapsible:true,
           modal:true,
           iconCls: 'icon-w-list',
           onClose:function()
           {
	           
	            PatOrdLst.curIndex = -1;
                PatOrdLst.curRow = null;
	            ordLstEditIndex = undefined;
	        }
  
       })
	
}

//初始化医嘱项目详细gd
function InitPatOrdLstDg(rowData)
{
	setValueById('lstTarDr',rowData.TTarDr);
   //初始化datagrid
   $HUI.datagrid("#patordlstdg",{
       url:$URL+'?ClassName='+"web.INSUAuditIP"+'&QueryName='+"AuditDetailsList"+'&AdmDr='+SelAdmDr+'&BillDr='+SelBillDr+'&TarDr='+rowData.TTarDr+'&MotherAdmFlag='+rowData.MotherAdmFlag+'&TmpOutDrugFlag='+rowData.TmpOutDrugFlag+'&Price='+rowData.TPrice,
       width: '100%',
	   selectOnCheck: true,
	   checkOnSelect: false,
       border:false,
       pagination:true,
       pageSize:10,
	   pageList:[10,20,30],
       data: [],
        frozenColumns:
       [[ 
          {field:'lstck',title:'lstck',width:10,checkbox:true}
          ]],
       columns:[[
           {field:'TTarDesc',title:'项目名称',width:160},
           {field:'Txmdj',title:'项目等级',width:100},
           {field:'TPrice',title:'单价',width:60,align:'right'},
           {field:'TQty',title:'数量',width:60,align:'right'},
           {field:'TAmount',title:'金额',width:80,align:'right'},
           {field:'TInsuFlag',title:'调整为自费',width:100,align:'center',
            formatter:function(val,rowData,rowIndex){
                  return (val=="Y") ? "是" : "否";
                },
             editor:{
	             type:'switchbox',
	             options:{   
		         onClass:'primary',
	             offClass:'gray',
	             onText:'是',
	             offText:'否',
	             onSwitchChange:function(event,obj){
		                RowTInsuFlagOnChange(obj.value,"patordlstdg",PatOrdLst.curIndex,PatOrdLst.curRow);
		             }
		             }
	             }
           },
           {field:'TOEORIDr',title:'TOEORIDr',width:80,hidden:true},
           {field:'TOeordDate',title:'医嘱日期',width:90},
           {field:'TOeordTime',title:'医嘱时间',width:80},
           {field:'TArcimDesc',title:'医嘱名称',width:80},
           {field:'TOEExeDr',title:'TOEExeDr',width:80}
           
          
       ]],
       onBeforeLoad:function(param){
			//param.ClassName='web.INSUAuditIP';
			//param.QueryName='GetDiagnosInfo';
			//param.AdmDr=SelAdmDr;
			
		},	
		onClickRow : function(rowIndex, rowData) {
           onClickOrdLstRow(rowIndex)
           PatOrdLst.curIndex=rowIndex;
           PatOrdLst.curRow=rowData;
           
           RowTInsuFlagCheck('patordlstdg',rowIndex, rowData) ;
       }
       
   });
   
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

 var editIndex = undefined;
 function endEditing(){
           if (editIndex == undefined){return true}
           if ($('#chkpatdg').datagrid('validateRow', editIndex)){
               $('#chkpatdg').datagrid('endEdit', editIndex);
               SelPatModifyAfterRowObj = $('#chkpatdg').datagrid('getRows')[editIndex];
               editIndex = undefined;
               return true;
           } else {
               return false;
           }
       }
      
     
  function onClickCell(index, field)
       {
           if (editIndex != index){
               if (endEditing()){
                   $('#chkpatdg').datagrid('selectRow', index)
                           .datagrid('beginEdit', index);
                   var ed = $('#chkpatdg').datagrid('getEditor', {index:index,field:field});
                   if (ed){
                       ($(ed.target).data('textbox') ? $(ed.target).textbox('textbox') : $(ed.target)).focus();
                   }
                   
                   editIndex = index;
               } else {
                   setTimeout(function(){
                       $('#chkpatdg').datagrid('selectRow', editIndex);
                   },0);
               }
           }
       }
   
var ordEditIndex=undefined;
var OrdmodifyBeforeRow = {};
var OrdmodifyAfterRow = {};
function OrdEndEditing(){
       if (ordEditIndex == undefined){return true}
       if ($('#chkpatOrddg').datagrid('validateRow', ordEditIndex)){
           //列表中下拉框实现
           $('#chkpatOrddg').datagrid('endEdit', ordEditIndex);
           OrdmodifyAfterRow = $('#chkpatOrddg').datagrid('getRows')[ordEditIndex];
           
           
			// tangzf 20200407 start
			//var thisEd = $('#chkpatOrddg').datagrid('getEditor', {index: ordEditIndex, field: 'TInsuFlag'});
			//if (thisEd) {
				//$HUI.switchbox(thisEd.target,'setValue',OrdmodifyAfterRow.TInsuFlag);
				//RowTInsuFlagOnChange(OrdmodifyAfterRow.TInsuFlag,"chkpatOrddg",PatOrd.curIndex,PatOrd.curRow);
				HISUIDataGrid.setFieldValue('TInsuFlag',(OrdmodifyAfterRow.TInsuFlag=="是") ? "Y" : "N",ordEditIndex,'chkpatOrddg');
				var td = $('.datagrid-view').find('.datagrid-body td[field="' + 'TInsuFlag' + '"]')[ordEditIndex];
				var div = $(td).find('div')[0];
				$(div).text((OrdmodifyAfterRow.TInsuFlag=="Y") ? "是" : "否");
			//}
			// tangzf 20200407 end 避免选中后 开关默认为否

			
           ordEditIndex = undefined;
           return true;
       } else {
           return false;
       }
   }
function onClickOrdRow(index,rowData){
   if (ordEditIndex!=index) {
       if (OrdEndEditing()){
           $('#chkpatOrddg').datagrid('selectRow', index)
           $('#chkpatOrddg') .datagrid('beginEdit', index);
           ordEditIndex = index;
          // OrdmodifyBeforeRow = $.extend({},$('#chkpatOrddg').datagrid('getRows')[ordEditIndex]);
       } else {
           $('#chkpatOrddg').datagrid('selectRow', ordEditIndex);
       }
   }

}



var ordLstEditIndex=undefined;
function OrdLstEndEditing(){
       if (ordLstEditIndex == undefined){return true}
       if ($('#patordlstdg').datagrid('validateRow', ordEditIndex)){
           //列表中下拉框实现
           $('#patordlstdg').datagrid('endEdit', ordLstEditIndex);
          // tangzf 20200407 start
         var selectRow = $('#patordlstdg').datagrid('getRows')[ordLstEditIndex];
			//var thisEd = $('#chkpatOrddg').datagrid('getEditor', {index: ordEditIndex, field: 'TInsuFlag'});
			//if (thisEd) {
				//$HUI.switchbox(thisEd.target,'setValue',OrdmodifyAfterRow.TInsuFlag);
				//RowTInsuFlagOnChange(OrdmodifyAfterRow.TInsuFlag,"chkpatOrddg",PatOrd.curIndex,PatOrd.curRow);
				HISUIDataGrid.setFieldValue('TInsuFlag',(selectRow.TInsuFlag=="是") ? "Y" : "N",ordLstEditIndex,'patordlstdg');
				var td = $('#PatOrdLstWin').find('td[field="' + 'TInsuFlag' + '"]')[ordLstEditIndex+1];
				var div = $(td).find('div')[0];
				$(div).text((selectRow.TInsuFlag=="Y") ? "是" : "否");
			//}
			// tangzf 20200407 end 避免选中后 开关默认为否
           ordLstEditIndex = undefined;
           return true;
       } else {
           return false;
       }
   }
function onClickOrdLstRow(index){
   if (ordLstEditIndex!=index) {
       if (OrdLstEndEditing()){
           $('#patordlstdg').datagrid('selectRow', index)
                   .datagrid('beginEdit', index);
           ordLstEditIndex = index;
          // OrdmodifyBeforeRow = $.extend({},$('#chkpatOrddg').datagrid('getRows')[ordEditIndex]);
       } else {
           $('#patordlstdg').datagrid('selectRow', ordLstEditIndex);
       }
   }
}

function EditIndexDefault()
{
	
	ordLstEditIndex=undefined;
	ordEditIndex=undefined;
	
}
/*头菜单传值*/
function setEprMenuForm(episodeId, patientId) {
	var frm = dhcsys_getmenuform();
	if (frm && (frm.EpisodeID.value != episodeId)) {
		frm.EpisodeID.value = episodeId;
		frm.PatientID.value = patientId;
	}
}
