var DiagnosListDataGrid;
var DiagnosHistoryDataGrid;
var MRDiagTemplateDetailDataGrid;
var DiagnosSearchListDataGrid;
var DiagPropertyChangeLogDataGrid;
var editRow = undefined;
var ItemzLookupGrid;
var DiagnosValue;
var DiagnosListSelectedRow="";
var dialog;
var SelMRCICDRowid="";
var selMRDiagType="";
var findCondition="";
var DiagPropertyShowFlag=1;
var DateDefaultFormat=tkMakeServerCall("websys.Conversions","DateFormat")
$(window).load(function(){
	//初始化本次诊断
	InitDiagnosList();
	//初始化模板列表
	InitMRDiagTemplate("MRDiagTemplate")
	//初始化历史诊断列表
	InitDiagnosHistoryList();
	//模板明细列表
	InitMRDiagTemplateDetail();
	
	//初始化诊断类型
	InitMRDiagType("MRDiagType");
	//初始化其他信息、诊断相关
	ReAdmStatusInit();
	//初始化特殊人群
	CreaterSpecial();
	//初始化单病种信息
	InitSingleDisList();
	 //初始化诊断combogrid
    InitDiagnosComboGrid();
	if (UserICDSyndrome=="1"){
     	InitSyndromeComboGrid("SyndromeSearch_1");
    }
   //发病日期默认当天
    $('#IDate').datebox('setValue', myformatter(new Date()));
    if(EpisodeType=="I"){
	    $('#Text_OPDoagnos').val(INDiag);
	}
	$('#AddSyndrome').click(AddSyndromeClickHandle);
	if (UseDKBFlag=="1"){
		$('#OpenUseDKB').click(SaveUseDKBFlag);
		if (UserOpenUseDKBFlag==1){
			$("#OpenUseDKB").attr('checked', true);
			UseDKBFlag=1;
		}else if (UserOpenUseDKBFlag==0){
			UseDKBFlag=0;
		}
	}else{
		$("[name='USEDKB']").css("display","none")
	}
	//$('#DiagnosSearch').combogrid().next('span').find('input').focus();
});
function SaveUseDKBFlag(){
	if ($("#OpenUseDKB").is(":checked")) {UseDKBFlag="1";}else{UseDKBFlag="0";} //  GetConfigNode1
	var rtn=tkMakeServerCall("web.DHCDocConfig","SaveConfig1","UserOpenDKB",session['LOGON.USERID'],UseDKBFlag);
}
//将事件定义放到ready中,对于easyui的异步处理,将初始化的逻辑代码放到页面加载完成之后的window.load()中,且提高速度
$(document).ready(function(){
    //常用诊断模板维护
    $("#MyDiagnosEdit").click(function(){
	    if (window.dialogArguments!=undefined){
            $.messager.alert("提示","模态窗口不支持,请到对应功能菜单下处理!");
            return false;
        }else{
	        MydiagnosEditshow();
	    }
	});
	//查看全部诊断
	$("#BShowMRDiagnos").click(function(){
		if (window.dialogArguments!=undefined){
            $.messager.alert("提示","模态窗口不支持,请到对应功能菜单下处理!");
            return false;
        }else{
	       var repUrl="dhcdocdiagnostype.csp?mradm="+mradm+"&ICDType="+"ALL";
	       window.open(repUrl,"_blank","height=600,width=800,left=50,top=50,status=yes,toolbar=no,menubar=no")
	    }
	});
     $("#BSaveDiagnos").click(function(){
	    //var SelMRCICDRowid = $('#DiagnosSearch').combogrid('getValue');
	    if((!isNaN(SelMRCICDRowid))&&(SelMRCICDRowid!="")){
		    if(!CheckDiagIsEnabled(SelMRCICDRowid)) return false;
		    InsertMRDiagnos(SelMRCICDRowid)
		}else{
			var MRDIADesc=$("#DiagnosNotes").val()
			MRDIADesc=MRDIADesc.replace(/[\\\@\#\$\%\^\&\*\{\}\:\"\<\>\?]/g,"");
			if(MRDIADesc==""){
			  var MRDIADesc = $('#DiagnosSearch').combogrid('getValue');
			}
			MRDIADesc=MRDIADesc.replace(/[\\\@\#\$\%\^\&\*\{\}\:\"\<\>\?]/g,"");
			if(MRDIADesc==""){
				//$.messager.alert("提示","禁止在诊断处录入非标准ICD，请在诊断注释处录入","error");
                //return false;
                InsertOtherInfo(true)
			}else{
				InsertMRDiagnos("")
			}
			
		}
	    
	 });
     // 
     $("#BCreate").click(function(){
	    $("#Text_DiagTemplateName").css('display',''); 	
	    $("#BAdd").css('display',''); 
	    $("#Text_DiagTemplateName").val('')
	 });
	 //增加诊断录入个人模板标签
	 $("#BAdd").click(function(){
	    NewPrivateAdd();
	 });
	 //增加个人模板记录
	 $("#BSave").click(function(){
	    PrivateSave();
	 });

	 $("input[name='DiagnosCat']").click(function(){
		DiagnosCatChange();
		findCondition="";
	 });
	 //诊断类型默认
	 $("input[name='DiagnosCat'][value="+ChinaMedFlag+"]").attr("checked",true);
	 //页面键盘输入事件控制(回车,Tab)
	 $(document.body).bind("keyup",BodykeydownHandler)
	 //$(document.body).bind("keyup",BodykeyupHandler)
     $("#FormSure").click(function(){
	    if (SaveMRDiagnos()){
		    CloseDiagPropertyWindow();
		}
	    
	});
	$("#FormClose").click(function(){
		 CloseDiagPropertyWindow();
	});
	$('#ChangeDiagDisplayDesc').click(ChangeDiagDisplayDescClick);
	$('#BtnFormSure').click(ChangeDiagDescWinSure);
	$('#BtnFormClose').click(ChangeDiagDescWinClose);
    InitDiagPropertyChangeLog();
	////----------
	if (WeekGestationDia!=""){
		//InitLMPWindow();
	}
});
//DiagPLRowID:%String,DiagPLContent:%String,DiagPLUser:%String,DiagPLUpdateDate:%String,DiagPLUpdateTime
function InitDiagPropertyChangeLog(){
	var DiagnosProLogListColumns=[[ 
            { field: 'DiagPLRowID', title: '诊断表id', hidden:true
			}, 
			{ field: 'DiagPLContent', title:'更新内容', width: 230,
				formatter:function(value,rec){ 
					value=value.replace(/\\/g,"");
					value= '<a class="easyui-tooltip" title="'+value+'">'+value+'</a>';
					return value;
					//return value.replace(/\\/g,""); 
			    }
			},
			{ field: 'DiagPLUser', title: '更新人', width: 80, align: 'center', sortable: true
			},
			{ field: 'DiagPLUpdateDate', title: '更新日期', width: 100, align: 'left', sortable: true, resizable: true
			},
			{ field: 'DiagPLUpdateTime', title: '更新时间', width: 100, align: 'left', sortable: true, resizable: true
			}
    ]];
	DiagPropertyChangeLogDataGrid=$('#tabDiagPropertyChangeLog').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //为true时 不显示横向滚动条
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"DiagPLRowID",
		pageList : [15,50,100,200],
		columns :DiagnosProLogListColumns,
		method:'get',
		onBeforeLoad:function(param){
			if (param.Arg1!=undefined){
				param.ClassName ='web.DHCMRDiagnos';
				param.QueryName ='GetDiagProChangeLogList';
				//param.Arg1 =1;
				param.ArgCnt =1;
			}
			
		},
		onLoadSuccess: function(){
			$(".easyui-tooltip").tooltip({
                 onShow: function () {
                     $(this).tooltip('tip').css({
	                     'font-size': '24px',
	                     'border-color': '#FFCD41',
                         'background-Color': '#FFCD41'
                         
                     });
                 }
             });
		}

	});
}
function CloseDiagPropertyWindow(){
	$(".dynamic_tr").remove();
	$('#FormWindow').window('close');
	$('#ProChangeList').css('display', 'none');
	$("#SelDiagRowId").val("");
	$("#SelTKBRowId").val("");
}
function BodykeydownHandler(e) {
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
   //浏览器中Backspace不可用  
   var keyEvent;   
   if(e.keyCode==8){   
       var d=e.srcElement||e.target;   
        if(d.tagName.toUpperCase()=='INPUT'||d.tagName.toUpperCase()=='TEXTAREA'){   
            keyEvent=d.readOnly||d.disabled;   
        }else{   
            keyEvent=true;   
        }   
    }else{   
        keyEvent=false;   
    }   
    if(keyEvent){   
        e.preventDefault();   
    }   
	//回车事件或者
	if (keyCode==13) {
		if (SrcObj && SrcObj.id=="DiagnosNotes") {
			$("#DiaD").focus();
			return false;
		}
	}
	//左键移动诊断状态
	if (keyCode==37) {
		if (SrcObj && SrcObj.id=="DiaW") {
			$("#DiaD").focus();
			return false;
		}
		if (SrcObj && SrcObj.id=="DiaH") {
			$("#DiaW").focus();
			return false;
		}
	}
	//右键移动诊断状态
	if (keyCode==39) {
		if (SrcObj && SrcObj.id=="DiaD") {
			$("#DiaW").focus();
			return false;
		}
		if (SrcObj && SrcObj.id=="DiaW") {
			$("#DiaH").focus();
			return false;
		}
	}
	if ((SrcObj)&& ((SrcObj.id=="BPSystolic")||(SrcObj.id=="BPDiastolic")||(SrcObj.id=="Form_BPSystolic")||(SrcObj.id=="Form_BPDiastolic"))) {
	    if (((keyCode >= 46) && (keyCode < 58))|| ((keyCode >= 96) && (keyCode < 106))|| (keyCode==8)|| (keyCode==37)|| (keyCode==39)) {
		}else{
			debugger; 
			//window.event.keyCode = 0;
			var c=$("#"+SrcObj.id+""); 
			
            if(/[^\d.]/g.test(c.val())){//替换非数字字符  
              var temp_amount=c.val().replace(/[^\d]/g,'');  
              $("#"+SrcObj.id+"").val(temp_amount);  
            } 
            window.event.keyCode = 0;
            return websys_cancel();
		}	
	}
	
}
function PrivateSave()
{
	var rows = DiagnosListDataGrid.datagrid('getSelected');
	var DiagnosStr="";
	var MRDiagnosRowID="";
	if (UserICDSyndrome!="1"){
		DiagnosStr=rows.DiagnosCodeRowid;
		if (DiagnosStr==""){
			DiagnosStr=""+"$"+rows.DiagnosMRDesc
		}
	}else{
		/*if (rows.DiagnosCodeRowid==""){
			DiagnosStr=""+"$"+rows.DiagnosMRDesc
		}else{*/
			MRDiagnosRowID=rows.DiagnosValue;
		    DiagnosStr=cspRunServerMethod(GetGroupICDInfoMethod,MRDiagnosRowID,"1");
		//}
	}
	var selValue = $("#Combo_DiagTemplate").combobox("getValue");
	if(selValue==""){
		$.messager.alert("提示","没有选择个人模板！","error");
        return false;
	}
	var USERID = session['LOGON.USERID'];
	var k=1
    var RetStr = cspRunServerMethod(PrivateSaveMethod, USERID, selValue, DiagnosStr, k);
    var Ret=RetStr.split("^")[0]
    var Message=RetStr.split("^")[1]
    if((Ret==0)&&(Message=="")){
	    $.messager.show({title:"提示",msg:"保存成功"});
	    LoadMRDiagTemplateDetailDataGrid()
	    dialog.dialog( "close" );
	}else if(Message!=""){
		$.messager.alert("提示","保存失败"+Message+"诊断在该模板中已存在！","error");
        return false;
	}else{
		$.messager.alert("提示","保存失败","error");
        return false;
	}
}
function ReSetFocus(){
	var CurrentPagNum=$(".pagination-num").val()
	//if (+CurrentPagNum>1){
		window.setTimeout(function (){
			var CurrentOrdName=$('#DiagnosSearch').combogrid('getValue');
			var CurrentOrdText=$('#DiagnosSearch').combogrid('getText');
			if(CurrentOrdName!=""){
				var CheckValue=/^\d+$/;
				if ((CheckValue.test(CurrentOrdName))&&(CheckValue.test(CurrentOrdText))){
					SelMRCICDRowid="";
					$('#DiagnosSearch').combogrid("setValue","");
					$('#DiagnosSearch').combo("setText", "")
				}
			}
			setTimeout(function() {
				$('#DiagnosSearch').next('span').find('input').focus();
				window.returnValue=false;
			},50)
		},100)
	//}
	
}



function InitDiagnosComboGrid()
{
	var fileview = $.extend({}, $.fn.datagrid.defaults.view, { 
	       onAfterRender: function (target) { ReSetFocus(); }
	       //,onBeforeRender:function (target, rows){ReSetSelect();} 
	});
	$('#DiagnosSearch').combogrid({
		panelWidth:500,
		panelHeight:435,
		delay: 0,    
		mode: 'remote', 
		view: fileview,   
		//url: "./dhcdoc.cure.query.combo.easyui.csp", 
		url:PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 15,//每页显示的记录条数，默认为10   
		pageList: [15],//可以设置每页记录条数的列表   
		method:'get', 
		idField: 'HIDDEN',    
		textField: 'desc',    
		columns: [[    
			{field:'desc',title:'诊断名称',width:400,sortable:true,
				formatter:function(value,rec){ 
				    var tooltipText=value.replace(/\ +/g,"")
				    var len=value.split(findCondition).length;
				    var value1="";
				    for (var i=0;i<len;i++){
					    var otherStr=value.split(findCondition)[i];
					    if (i==0){
						    if (otherStr!=""){
							    value1=otherStr
							}
						}else{
						    value1=value1+"<font color='red'>"+findCondition+"</font>"+otherStr;
						}
					}
				    value="<span class='easyui-tooltip' title="+tooltipText+">"+value1+"</span>" //title="+tooltipText+"
                    return value;     
                }  
			},
			{field:'code',title:'code',width:120,sortable:true},
			{field:'HIDDEN',title:'HIDDEN',width:120,sortable:true,hidden:true}
		]],
		keyHandler:{
			up: function () {
                //取得选中行
                var selected = $('#DiagnosSearch').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#DiagnosSearch').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                        $('#DiagnosSearch').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#DiagnosSearch').combogrid('grid').datagrid('getRows');
                    $('#DiagnosSearch').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }
             },
             down: function () {
              //取得选中行
                var selected = $('#DiagnosSearch').combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#DiagnosSearch').combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#DiagnosSearch').combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#DiagnosSearch').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#DiagnosSearch').combogrid('grid').datagrid('selectRow', 0);
                }
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 
			    //文本框的内容为选中行的的字段内容
                var selected = $('#DiagnosSearch').combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      if (UseDKBFlag!="1"){ 
			          if(!CheckDiagIsEnabled(selected.HIDDEN)) {
						  findCondition="";
				         $('#DiagnosSearch').combo("setText", "");
				         setTimeout(function() {
								$('#DiagnosSearch').next('span').find('input').focus();
								window.returnValue=false;
						 },50);
						 $('#DiagnosSearch').combogrid('hidePanel');
				         return false;
				      }
				      DHCDocUseCount(selected.HIDDEN, "User.MRCICDDx")
				  }else{
					  DHCDocUseCount(selected.HIDDEN, "User.TKBTrem")
				  }
			      $('#DiagnosSearch').combogrid("options").value=selected.HIDDEN;
			      SelMRCICDRowid=selected.HIDDEN;
			    }
                //选中后让下拉表格消失
                $('#DiagnosSearch').combogrid('hidePanel');
                if (UseDKBFlag==1){
	                var RetStr = cspRunServerMethod(GetDiagTempData, SelMRCICDRowid);
					if (RetStr!=""){
						var RetStrArr=RetStr.split("^");
						var DKBBCRowId=RetStrArr[0]; //属性模板Id
						var emptyInfo=RetStrArr[1];
						if (emptyInfo!="") {
							if (InsertMRDiagnos(SelMRCICDRowid)) return true;
						}
					}
	                
	            }
                var DiagnosCat=$('input:radio[name="DiagnosCat"]:checked').val();
                if ((UserICDSyndrome=="1")&&(DiagnosCat==1)){
		        	$('#SyndromeSearch_1').next('span').find('input').focus();
	            }else{
					$("#DiagnosNotes").focus();
	            }
            },

			query:function(q){
				if (this.AutoSearchTimeOut) {
					window.clearTimeout(this.AutoSearchTimeOut)
					this.AutoSearchTimeOut=window.setTimeout("LoadDiagnosData('"+q+"')",400)
				}else{
					this.AutoSearchTimeOut=window.setTimeout("LoadDiagnosData('"+q+"')",400)
				}
				$('#DiagnosSearch').combogrid("setValue",q);
				findCondition=q;
                var reg= /^[A-Za-z]+$/;
				if (reg.test(findCondition)) {
					findCondition=findCondition.toUpperCase()
				}
				//LoadDiagnosData(q);
				
            }
		},
		/*onSelect: function (){  //onClickRow
			var selected = $('#DiagnosSearch').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  //if(!CheckDiagIsEnabled(selected.HIDDEN)) return false;
			  $('#DiagnosSearch').combogrid("options").value=selected.HIDDEN;
			  SelMRCICDRowid=selected.HIDDEN
			  if (UserICDSyndrome=="1"){
			  	$('#SyndromeSearch_1').next('span').find('input').focus();
			  }else{
			  	$("#DiagnosNotes").focus();
			  }
			}
		},*/onClickRow:function (rowIndex, rowData){
			var selected = $('#DiagnosSearch').combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  if (UseDKBFlag!="1"){ 
			          if(!CheckDiagIsEnabled(selected.HIDDEN)) {
				         $('#DiagnosSearch').combo("setText", "");
						 findCondition="";
				         setTimeout(function() {
								$('#DiagnosSearch').next('span').find('input').focus();
								window.returnValue=false;
						 },50);
						 $('#DiagnosSearch').combogrid('hidePanel');
				         return false;
				      }
				      DHCDocUseCount(selected.HIDDEN, "User.MRCICDDx")
			  }else{
				  DHCDocUseCount(selected.HIDDEN, "User.TKBTrem")
			  }
			  $('#DiagnosSearch').combogrid("options").value=selected.HIDDEN;
			  SelMRCICDRowid=selected.HIDDEN
			  if (UseDKBFlag==1){
	                var RetStr = cspRunServerMethod(GetDiagTempData, SelMRCICDRowid);
					if (RetStr!=""){
						var RetStrArr=RetStr.split("^");
						var DKBBCRowId=RetStrArr[0]; //属性模板Id
						var emptyInfo=RetStrArr[1];
						if (emptyInfo!="") {
							if (InsertMRDiagnos(SelMRCICDRowid)) return true;
						}
					}
	          }
			  if (UserICDSyndrome=="1"){
			  	$('#SyndromeSearch_1').next('span').find('input').focus();
			  }else{
			  	$("#DiagnosNotes").focus();
			  }
			}
		},onLoadSuccess: function(){
             $(".easyui-tooltip").tooltip({
                 onShow: function () {
	                // $(".easyui-tooltip").tooltip.content=$(this).context.innerHTML
                     $(this).tooltip('tip').css({
	                     'font-size': '24px',
	                     'border-color': '#FFCD41',
                         'background-Color': '#FFCD41'
                         
                     });
                 }
             });
       },onChange:function(newValue, oldValue){
	       if (newValue=="") SelMRCICDRowid="";
	   },
	   onShowPanel:function(){
		   if (findCondition==""){LoadDiagnosData("")}
	   }
	});
}
function LoadDiagnosData(q)
{
	var desc=q;
	//if (desc=="") return;
	var reg= /^[A-Za-z]+$/;
	var allEn="";
	if (reg.test(q)) {
		allEn="Y";
	} 
	//var ICDType=$("#DiagnosCat").val();
	var opts = $('#DiagnosSearch').combogrid("grid").datagrid("options");
	var ICDType=$('input:radio[name="DiagnosCat"]:checked').val()
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCMRDiagnos';
	queryParams.QueryName ='LookUpWithAlias';   
	queryParams.Arg1 =desc;
	queryParams.Arg2 ="";
	queryParams.Arg3 =allEn;
	queryParams.Arg4 ="";
	queryParams.Arg5 =ICDType;
	queryParams.Arg6 =session['LOGON.USERID'];
	queryParams.Arg7 =opts.pageSize;
	queryParams.Arg8 =UseDKBFlag;
	queryParams.ArgCnt =8;
	
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	opts.queryParams = queryParams;
	//reload 等同于'load'方法，但是它将保持在当前页。
	//$('#DiagnosSearch').combogrid("grid").datagrid("reload");
	$('#DiagnosSearch').combogrid("grid").datagrid("load");
	
}
/*function DiagnosItemLookupSelect(text)
{
	$("#DiagnosSearch").val(text.split("^")[0])
	SelMRCICDRowid=text.split("^")[1]
}*/
function NewPrivateAdd()
{
	var PrivateDesc=$("#Text_DiagTemplateName").val().replace(/(^\s*)|(\s*$)/g, "");
	if (PrivateDesc == '') {
		$.messager.alert("提示","新增的个人模板的名称为空!","error");
        return false;
    }
   var USERID = session['LOGON.USERID'];
   var CTLOCID = session['LOGON.CTLOCID'];
   var obj=$('#Combo_DiagTemplate').combobox('getData');
   var INDEXNum=1,RepeatFlag=0
   for(var i=0;i<obj.length;i++){
	   if(obj[i].DHCDIAMASRowid!=""){
		   INDEXNum=Number(INDEXNum)+1
		   if(PrivateDesc==obj[i].DHCDIADESC){
			   RepeatFlag=1
		   }
	   }
   }
   if(RepeatFlag==1){
	   $.messager.alert("提示","您添加的模板【"+PrivateDesc+"】,已存在,请直接选择保存","error");
        return false;
   }
   Ret = cspRunServerMethod(AddPrivateTemplateMethod, PrivateDesc, USERID, CTLOCID, INDEXNum)
   InitMRDiagTemplate("Combo_DiagTemplate")
   InitMRDiagTemplate("MRDiagTemplate")
   $("#Text_DiagTemplateName").css('display','none'); 	
   $("#BAdd").css('display','none'); 
}
function InitMRDiagTemplate(param)
{
	$("#"+param+"").combobox({
		editable: false,
		multiple:false,
		mode:"remote",
		method: "GET",
		selectOnNavigation:true,
	  	valueField:'DHCDIAMASRowid',   
	  	textField:'DHCDIADESC',
	  	url:"./dhcdoc.cure.query.combo.easyui.csp",
	  	onBeforeLoad:function(param){
			param.ClassName = 'web.DHCMRDiagnosNew';
			param.QueryName = 'DiagTemplateList';
			param.Arg1 =session['LOGON.USERID'];
			param.ArgCnt =1;
		},
		onSelect:function() {
			//诊断模板combobox的选择改变,需要重载诊断模板明细的数据
			if (param=="MRDiagTemplate") LoadMRDiagTemplateDetailDataGrid();
		},
		onLoadSuccess:function(){
			var defaultId=$("#"+param+"").combobox('getData')[0].DHCDIAMASRowid;
			//onLoadSuccess和onBeforeLoad会被加载两遍判断Value和text相等是为了在第一次加载没有赋值上默认值的时候调用一次
			if (($(this).combobox("getValue")==$(this).combobox('getText'))&&(defaultId!="")) {
				//console.log("onLoadSuccess param:"+param+",defaultId:"+defaultId+","+$(this).combobox("getValue")+","+$(this).combobox('getText'))
				$("#"+param+"").combobox('setValue',defaultId);
				if (param=="MRDiagTemplate") {
					//诊断模板combobox的选择,需要重载诊断模板明细的数据
					LoadMRDiagTemplateDetailDataGrid();
				}
			}else{
				var DiagTemplateId=$("#MRDiagTemplate").combobox("getValue")
				if(DiagTemplateId=="--请选择模板--"){
					LoadMRDiagTemplateDetailDataGrid();
				}
			}
        }
	});
	
	return cancelBubble();
}
function InitMRDiagType(para1)
{
	//
	$("#"+para1+"").combobox({
		//editable:false,
		//panelHeight:80,
		multiple:false,
		mode:"remote",
		method: "GET",
		selectOnNavigation:true,
	  	valueField:'DTYPRowid',   
	  	textField:'DTYPDesc',
	  	url:'./dhcdoc.cure.query.combo.easyui.csp',
	  	onBeforeLoad:function(param){
		  	  //alert(selMRDiagType)
					param.ClassName = 'web.DHCMRDiagnosNew';
					param.QueryName = 'GetDiagnosTypeList';
					param.Arg1 =EpisodeType;
					param.Arg2 =selMRDiagType;
					param.Arg3 =mradm;
					param.ArgCnt =3;
		},
		keyHandler:{
			up: function () {
				var Data=$("#"+para1+"").combobox("getData");
				var CurValue=$("#"+para1+"").combobox("getValue");
                //取得上一行
                for (var i=0;i<Data.length;i++) {
					if (Data[i] && Data[i].DTYPRowid==CurValue) {
						if (i>0) $("#"+para1+"").combobox("select",Data[i-1].DTYPRowid);
						break;
					}
				}
             },
             down: function () {
				var Data=$("#"+para1+"").combobox("getData");
				var CurValue=$("#"+para1+"").combobox("getValue");
                //取得下一行
                for (var i=0;i<Data.length;i++) {
					if (CurValue!="") {
						if (Data[i] && Data[i].DTYPRowid==CurValue) {
							if (i < Data.length-1) $("#"+para1+"").combobox("select",Data[i+1].DTYPRowid);
							break;
						}
					}else{
						$("#"+para1+"").combobox("select",Data[0].DTYPRowid);
						break;
					}
				}
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },			
			enter: function () { 
				var CurValue=$("#"+para1+"").combobox("getValue");
				$("#"+para1+"").combobox("hidePanel");
				if (para1=="MRDiagType"){
					//$("#"+para1+"")  #MRDiagType
					$.messager.confirm("提示","是否确定保存诊断?",function(rtn){
						if (rtn) {
							//$("#BSaveDiagnos").click();
							InsertMRDiagnos(SelMRCICDRowid);
						}
					});
				}
            }
		},
		onSelect: function (){
			/*
			$.messager.confirm("提示","是否确定保存诊断?",function(rtn){
				if (rtn) $("#BSaveDiagnos").click();
			});
			*/
		},
		onShowPanel: function (){
			//选中第一行数据
			var Data=$('#MRDiagType').combobox("getData");
			for (var i=0;i<Data.length;i++) {
				$('#MRDiagType').combobox("select",Data[0].DTYPRowid);
				break;
			}
		}
	});
}
function InitSingleDisList()
{
	$("#SingleDisList").combobox({
		editable: false,
		multiple:false,
		mode:"remote",
		method: "GET",
		selectOnNavigation:true,
  	valueField:'DTYPRowid',
  	textField:'DTYPDesc',
  	url:"./dhcdoc.cure.query.combo.easyui.csp",
  	onBeforeLoad:function(param){
					param.ClassName = 'web.DHCMRDiagnosNew';
					param.QueryName = 'GetPAADMSingleDisInfoList';
					param.Arg1 =EpisodeID;
					param.ArgCnt =1;
		},
		onSelect: function(rec){   
		    var rtn=cspRunServerMethod(SetPAADMSingleDisMethod,rec.DTYPRowid)
		    if (rtn!=1){
		       $.messager.alert("提示", "保存单病种信息失败"+rtn, "error");
	         }
        }  
	});
}
function ReAdmStatusInit()
{
	if (ReAdmis==1){ReAdmis=true;}else{ReAdmis=false;}
	if (FirstAdm==1){FirstAdm=true;}else{FirstAdm=false;}
	if (OutReAdm==1){OutReAdm=true;}else{OutReAdm=false;}
	if (TransAdm==1){TransAdm=true;}else{TransAdm=false;}
	if (ILIFlag==1){ILIFlag=true;}else{ILIFlag=false;}
	$("#ReAdmis").attr('checked', ReAdmis);
	$("#FirstAdm").attr('checked', FirstAdm);
	$("#OutReAdm").attr('checked', OutReAdm);
	$("#TransAdm").attr('checked', TransAdm);
	$("#ILI").attr('checked', ILIFlag);
	$("#BPSystolic").val(BPSystolic);
	$("#BPDiastolic").val(BPDiastolic);
	$("#Weight").val(Weight);
    //初复诊状态点击事件
	$("#FirstAdm").click(function(){
		$("#ReAdmis").attr('checked',false);
		$("#OutReAdm").attr('checked',false);
		$("#TransAdm").attr('checked',false);
	 });
	 $("#ReAdmis").click(function(){
		$("#FirstAdm").attr('checked',false);
		$("#OutReAdm").attr('checked',false);
		$("#TransAdm").attr('checked',false);
	 });
	 $("#OutReAdm").click(function(){
		$("#ReAdmis").attr('checked',false);
		$("#FirstAdm").attr('checked',false);
		$("#TransAdm").attr('checked',false);
	 });
	 $("#TransAdm").click(function(){
		$("#ReAdmis").attr('checked',false);
		$("#OutReAdm").attr('checked',false);
		$("#FirstAdm").attr('checked',false);
	 });
}
function MRDiagnosStatusChange(Status)
{
  if(Status=="QZ"){
	  $("#DiaH").css("background-color", "");
	  $("#DiaD").css("background-color", "#1C86EE");
	  $("#DiaW").css("background-color", "");
	  DiagnosStatus=DiaD
  }else if(Status=="DZ"){
	  $("#DiaH").css("background-color", "");
	  $("#DiaD").css("background-color", "");
	  $("#DiaW").css("background-color", "#1C86EE");
	  DiagnosStatus=DiaW
  }else{
	  $("#DiaH").css("background-color", "#1C86EE");
	  $("#DiaD").css("background-color", "");
	  $("#DiaW").css("background-color", "");
	  DiagnosStatus=DiaH
  }
  selMRDiagType=$("#MRDiagType").combobox("getValue");
  $('#MRDiagType').combobox('reload'); 
  $('#MRDiagType').combobox().next('span').find('input').focus(
      /*window.setTimeout(function(){
	     // $("#MRDiagType").combobox('setValue',selMRDiagType);
	      $('#MRDiagType').combobox("select",selMRDiagType);
	  },1000)*/
  );
  
  
}
function DiagnosSearch(value,name){ 
	///todo 加入诊断查询的代码
} 
///查询本次诊断列表诊断
function InitDiagnosList()
{
	var DiagnosListBar = [{
            text: '删除',
            iconCls: 'icon-remove',
            handler: function() { //getSelected  getSelections
			   var rows = DiagnosListDataGrid.datagrid('getSelected');
			   if (rows) {
                       var index = DiagnosListDataGrid.datagrid('getRowIndex', rows);
	                   //DiagnosListDataGrid.datagrid("selectRow",DiagnosListSelectedRow)
					   DiagnosListDataGrid.datagrid("selectRow",index)
	                   var MRDiagnosRowid=rows.DiagnosValue
	                   var ret=DeleteMRDiagnos(MRDiagnosRowid);
					   if ((editRow = index)||(editRow==undefined)){
		                   editRow=undefined;
		               }
                } else {
                    $.messager.alert("提示", "请选择要删除的行", "error");
                }
	           
            }
        },
        '-', {
            text: '←',
            handler: function() {
	            var rows = DiagnosListDataGrid.datagrid('getSelected');
	            if (rows) {
		            AdjustMRDiagnosLevel(DiagnosListSelectedRow,-1);
		        }else{
			        $.messager.alert("提示", "请选择行", "error");
			    }
                
            }
        },
        '-', {
            text: '→',
            handler: function() {
              var rows = DiagnosListDataGrid.datagrid('getSelected');
	            if (rows) {
		            AdjustMRDiagnosLevel(DiagnosListSelectedRow,1);
		        }else{
			        $.messager.alert("提示", "请选择行", "error");
			    }
            }
        },
        '-', {
            text: '↑',
            handler: function() {
	            var rows = DiagnosListDataGrid.datagrid('getSelected');
	            if (rows) {
		            BMoveUpclickhandler("up");
		        }else{
			        $.messager.alert("提示", "请选择行", "error");
			    }
            }
        },
        '-', {
            text: '↓',
            handler: function() {
	            var rows = DiagnosListDataGrid.datagrid('getSelected');
	            if (rows) {
		            BMoveDownclickhandler("down");
		        }else{
			        $.messager.alert("提示", "请选择行", "error");
			    }
                
            }
        },
        '-', {
            text: '置顶',
            handler: function() {
	            var rows = DiagnosListDataGrid.datagrid('getSelected');
	            if (rows) {
		            BMoveUpclickhandler("Top");
		        }else{
			        $.messager.alert("提示", "请选择行", "error");
			    }
                
            }
        },
        '-', {
            text: '置底',
            handler: function() {
	            var rows = DiagnosListDataGrid.datagrid('getSelected');
	            if (rows) {
		            BMoveDownclickhandler("Bottom");
		        }else{
			        $.messager.alert("提示", "请选择行", "error");
			    }
                
            }
        },
        '-', {
            text: '保存',
            iconCls: 'icon-save',
            handler: function() {
	            if (editRow != undefined) {
		            var editors = DiagnosListDataGrid.datagrid('getEditors', editRow); 
		            var DiagnosNotechangevalue =  editors[0].target.val();
		            //var rows = DiagnosListDataGrid.datagrid('getSelected');
		            //var MRDiagnosNoteId=rows.DiagnosValue
					var rows = DiagnosListDataGrid.datagrid('getRows');
		            var MRDiagnosNoteId=rows[editRow].DiagnosValue;
		            var DiagPRowId=rows[editRow].DiagPRowId;
		            UpdateMrdiagNote(MRDiagnosNoteId, DiagnosNotechangevalue,DiagPRowId);
		            DiagnosListDataGrid.datagrid("endEdit", editRow);
		            editRow = undefined;
		            DiagnosListDataGrid.datagrid('load');
		            DiagnosListDataGrid.datagrid('unselectAll');
		            LoadDiagnosHistoryDataGrid();
					SaveMRDiagnosToEMR()
		        }
            }
        },
        '-', {
            text: '取消编辑',
            iconCls: 'icon-redo',
            handler: function() {
				if(editRow==undefined) return false;
                editRow = undefined;
                DiagnosListDataGrid.datagrid("rejectChanges");
                DiagnosListDataGrid.datagrid("unselectAll");
				DiagnosListDataGrid.datagrid('load');
            }
        },
        '-', {
            text: '添加到模板',
            iconCls: 'icon-add',
            handler: function() {
	            if (window.dialogArguments!=undefined){
					$.messager.alert("提示","模态窗口不支持,请到对应功能菜单下处理!");
					return false;
			    }
	            var rows = DiagnosListDataGrid.datagrid('getSelected');
			    if (rows) {
					   var index = DiagnosListDataGrid.datagrid('getRowIndex', rows);
					   DiagnosListDataGrid.datagrid("selectRow",index)
	                   //DiagnosListDataGrid.datagrid("selectRow",DiagnosListSelectedRow)
	                   var DiagnosCodeRowid=rows.DiagnosCodeRowid
	                   //if(DiagnosCodeRowid!=""){
		                   $("#dialog-form").css("display", ""); 
		                   $("#Text_DiagTemplateName").css('display','none'); 	
	                       $("#BAdd").css('display','none'); 
		                   dialog = $( "#dialog-form" ).dialog({
                              autoOpen: false,
                              height: 150,
                              width: 400,
                              modal: true
                           });
	                       dialog.dialog( "open" );
	                       InitMRDiagTemplate("Combo_DiagTemplate")
		               //}
                } else {
                    $.messager.alert("提示", "请选择需要添加到模板的诊断记录", "error");
                }
            }
        }];
	DiagnosListColumns=[[ 
	                  
                    { field: 'DiagnosValue', title: '诊断表id', hidden:true
					}, 
					{ field: 'DiagnosCodeRowid', title:'', hidden:true
					},
        			{ field: 'DiagnosType', title: '诊断类型', width: 80, align: 'center', sortable: true
					},
					{ field: 'DiagnosDesc', title: '诊断', width: 200, align: 'left', sortable: true, resizable: true,
						formatter:function(value,rec){ 
							if (rec.DiagPRowId!=""){
								var btn = '<a style="color:blue;cursor:pointer;" class="easyui-tooltip" title="'+rec.DiagnosDesc+'" onclick="DiagnosPropertyShow(\'' + rec.DiagnosValue + '\',\''+rec.DiagPRowId+ '\',\''+rec.DiagnosDesc+'\')">'+value+'</a>';
					            return btn;
							}else{
								return value;
							}
						}
					},
					{ field: 'DiagnosMRDesc', title: '诊断注释', width: 200, align: 'left', sortable: true, resizable: true,
					  editor : {
						  type : 'text',
						  options : {
						  }
					  }
					},
					{ field: 'DiagnosICDCode', title: 'ICD代码', width: 70, align: 'center', sortable: true, resizable: true
					},
					{ field: 'DiagStat', title: '诊断状态', width: 50, align: 'center', sortable: true, resizable: true
					},
					{ field: 'DiagnosDate', title: '诊断日期', width: 80, align: 'center', sortable: true, resizable: true
					},
					{ field: 'DiagnosOnsetDate', title: '发病日期', width: 80, align: 'center', sortable: true, resizable: true
					},
					{ field: 'DiagnosLeavel', title: '诊断级别', width: 80, align: 'center', sortable: true, resizable: true
					},
					{ field: 'DiagnosZX', title: '中医证型', width: 80, align: 'center', sortable: true, resizable: true,  
                        formatter:function(value,rec){  
		                   var ZYFlag=cspRunServerMethod(GetZYMRDiagnosFlag, rec.DiagnosValue)
		                   if(ZYFlag=="Y"){
			                   var btn = '<a class="editcls" onclick="DiagnosZXShow(\'' + rec.DiagnosValue + '\')">证型</a>';
						       return btn;
			               }
                           
                        }
                    },
					{ field: 'MRDIAMRDIADR', title: '症候对应的诊断',hidden:true
					},
					{ field: 'DiagPRowId', title: '诊断属性id',hidden:true
					}/*,
					{ field: 'DiagnosProperty', title: '诊断属性', width: 80, align: 'center', sortable: true, resizable: true, 
                        formatter:function(value,rec){  
		                   var btn = '<a class="editdiagcls" onclick="DiagnosPropertyShow(\'' + rec.DiagnosValue + '\',\''+rec.DiagPRowId+ '\',\''+rec.DiagnosDesc+'\')">诊断属性</a>';
					       return btn;
                        }
                    }*/
    			 ]];
	DiagnosListDataGrid=$('#tabDiagnosList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //为true时 不显示横向滚动条
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"DiagnosValue",
		pageList : [15,50,100,200],
		columns :DiagnosListColumns,
		toolbar :DiagnosListBar,
		method:'get', 
		onClickRow:function(rowIndex, rowData){
			DiagnosListSelectedRow=rowIndex
		},onLoadSuccess:function(data){ 
		    if (UserICDSyndrome==1){
			    DiagnosListDataGrid.datagrid('hideColumn', 'DiagnosZX');
		    }else{
			    if($('.editcls')) {
			        $('.editcls').linkbutton({text:'证型',plain:true});
		        }
		    }
		    if (UseDKBFlag==1){
			    /*if($('.editdiagcls')) {
			    	$('.editdiagcls').linkbutton({text:'诊断属性',plain:true});
		        }*/
		        DiagnosListDataGrid.datagrid('hideColumn', 'DiagnosICDCode');
			}/*else{
				DiagnosListDataGrid.datagrid('hideColumn', 'DiagnosProperty');
			}*/
		    $(this).datagrid('loaded');   
		    editRow=undefined;
		    $(".easyui-tooltip").tooltip({
                 onShow: function () {
                     $(this).tooltip('tip').css({
	                     'font-size': '24px',
	                     'border-color': '#FFCD41',
                         'background-Color': '#FFCD41'
                         
                     });
                 }
             });
        },
		onDblClickRow:function(rowIndex, rowData){
			if ((editRow != undefined)&&(editRow!=rowIndex)) {
				$.messager.alert("提示", "有正在编辑的行，请先点击保存或取消编辑", "error");
		        return false;
			}
			editRow = rowIndex;
			DiagnosListDataGrid.datagrid("beginEdit", rowIndex);
		},
		onBeforeLoad:function(param){
			param.ClassName ='web.DHCMRDiagnosNew';
			param.QueryName ='DiagnosList';
			param.Arg1 =mradm;
			param.ArgCnt =1;
		}

	});
	//LoadDiagnosListDataGrid();
	
	//return cancelBubble();
}
function LoadDiagnosListDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCMRDiagnosNew';
	queryParams.QueryName ='DiagnosList';
	queryParams.Arg1 =mradm;
	queryParams.ArgCnt =1;
	var opts = DiagnosListDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	DiagnosListDataGrid.datagrid('reload', queryParams);
}
///查询历史诊断列表诊断
function InitDiagnosHistoryList()
{
	DiagnosHistoryColumns=[[    
                    { field: 'Rowid', title: 'ICDCode', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'Desc', title:'诊断', width: 150, align: 'left', sortable: true
					},
					{ field: 'MRDesc', title:'备注', width: 100, align: 'center', sortable: true
					},
        			{ field: 'DoctDesc', title: '医生', width: 80, align: 'center', sortable: true
					},
					{ field: 'MRDate', title: '诊断日期', width: 100, align: 'center', sortable: true, resizable: true
					},
					{ field: 'MRtime', title: '诊断时间', width: 100, align: 'center', sortable: true, resizable: true,hidden:true
					},
					{ field: 'MainMRDIADr', title: '主诊断索引', hidden:true
					},
					{ field: 'MRDIADr', title: '诊断索引', hidden:true
					}, 
					{ field: 'AllowItemCatIDStr', title: '', width: 80, align: 'center', sortable: true, resizable: true,  
                        formatter:function(value,rec){ 
	                       var btn = '<a class="icon-add editcls1" onclick="HisMRDiagRepClick(\'' + rec.Rowid + '\',\''+rec.MRDIADr+'\')">重复记录</a>';
						   return btn;
                        }  

					},
					{ field: 'DiagPRowId', title: '诊断索引', hidden:true}
    			 ]];
	DiagnosHistoryDataGrid=$('#tabDiagnosHistory').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //为true时 不显示横向滚动条
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"MRDIADr",
		pageList : [15,50,100,200],
		columns :DiagnosHistoryColumns,
		method:'get', 
		onClickRow:function(rowIndex, rowData){
		},
		onLoadSuccess:function(data){ 
            $('.editcls1').linkbutton({text:'重复记录',plain:true});  
            $(this).datagrid('loaded');
        },
		onDblClickRow:function(rowIndex, rowData){
			HisdiagnosObjDbclick(rowIndex);
		},
		onBeforeLoad:function(param){
			param.ClassName ='web.DHCDocDiagnosNew';
			param.QueryName ='GetHistoryMRDiagnose';
			param.Arg1 =PatientID;
            param.Arg2 ="All";
            param.Arg3 =session['LOGON.CTLOCID'];
            param.ArgCnt =3;
		}

	});
	//LoadDiagnosHistoryDataGrid();
	
	//return cancelBubble();
}
function LoadDiagnosHistoryDataGrid()
{
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCDocDiagnosNew';
	queryParams.QueryName ='GetHistoryMRDiagnose';
	queryParams.Arg1 =PatientID;
	queryParams.Arg2 ="All";
	queryParams.Arg3 =session['LOGON.CTLOCID'];
	queryParams.ArgCnt =3;
	var opts = DiagnosHistoryDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	DiagnosHistoryDataGrid.datagrid('reload', queryParams);
}
function HisdiagnosObjDbclick() {
	if(!CheckIsAdmissions(EpisodeID)) return false;	
	if(!CheckBeforeInsertMRDiag()) return false;
		
	if (UserICDSyndrome=="0"){
		var row = DiagnosHistoryDataGrid.datagrid('getSelected');
		var DiagnosValue=row.Rowid
		//如果历史诊断包含诊断注释或是非ICD诊断,赋值给诊断注释
		var DiagnosDesc=row.MRDesc
		$("#DiagnosNotes").val(DiagnosDesc)
		if(DiagnosValue==""){
			//插入非ICD诊断
			InsertMRDiagnos("")
		}else{
			if(!CheckDiagIsEnabled(DiagnosValue)) return false;
			//插入ICD诊断
			if(!CheckDiagIsEnabled(DiagnosValue)) return false;
			InsertMRDiagnos(DiagnosValue)
		}
	}else{
		var row = DiagnosHistoryDataGrid.datagrid('getSelected');
		var MainMRDIADr=row.MainMRDIADr;
		var MRDIADr=row.MRDIADr;
		if (MainMRDIADr!=""){
			MRDIADr=MainMRDIADr;
		}
		var DiagnosValue=row.Rowid;
		var DiagPRowId=row.DiagPRowId;
		var DiagnosMRDesc=row.MRDesc;
		//ICD诊断重复性判断
		if (DiagnosValue!=""){
			if(!CheckDiagIsEnabled(DiagnosValue)) return false;
			//插入ICD诊断
			if(!CheckDiagIsEnabled(DiagnosValue)) return false;
			var Str=MarchDiagnosis(DiagnosValue);
			if (Str==1){
				var vaild = window.confirm("所加诊断在本次诊断中已经存在，请确认是否重复增加");
				if(!vaild) {return false;}
			}
		}else{
			var MRDIADesc=row.MRDesc
			//var MRDIADesc=$("#DiagnosNotes").val()
		    if(window.confirm("是否确定录入非标准ICD诊断?")){
			    MRDIADesc=MRDIADesc.replace(/[\\\@\#\$\%\^\&\*\{\}\:\"\<\>\?]/g,""); //MRDIADesc.replace(/(^\s*)|(\s*$)/g,'');
				if(MRDIADesc==""){
				  var MRDIADesc = $('#DiagnosSearch').combogrid('getValue');
				}
				MRDIADesc=MRDIADesc.replace(/[\\\@\#\$\%\^\&\*\{\}\:\"\<\>\?]/g,"");
			    if (MRDIADesc=="")
		         {
			       $.messager.alert("提示","禁止录入描述为空的为空的非标准ICD诊断.","error")
			       return false;
		         }
		         if(!UpdateMrdiagNote(mradm,MRDIADesc)) return false;
			}else{
				$("#DiagnosNotes").val('');
				return false;
			}
		}
		if (DiagPRowId!=""){
			var RetStr = cspRunServerMethod(GetDiagTempData, DiagnosValue);
			if (RetStr!=""){
				var RetStrArr=RetStr.split("^");
				var DKBBCRowId=RetStrArr[0]; //属性模板Id
				var emptyInfo=RetStrArr[1];
				//emptyInfo="糖尿病(分型,并发症)" //测试用
				if (emptyInfo=="") {
					SaveMRDiagnos(DKBBCRowId);
			    }else{
				    //$('#DiagnosSearch').combo("setText", row.Desc.split("(")[0]);
				    if (DiagnosMRDesc!="")$("#DiagnosNotes").val(DiagnosMRDesc);
				    findCondition=$.trim(row.Desc).split("(")[0];
				    //ShowFormWindow(DiagnosValue,"");
				    //$("#Form_DiagDesc").val(row.Desc);
				    $('#ProChangeList').css('display', '');
				    ShowFormWindow(DiagnosValue,row.MRDIADr,"FromHisDB");
				}
		    }
	    }else{
		    var LogDepRowid = session['LOGON.CTLOCID'];
			var LogUserRowid = session['LOGON.USERID'];
			var DiagnosType = $("#MRDiagType").combobox("getValue");
			var ret = cspRunServerMethod(CopyFromHistMRDiagMethod, LogDepRowid, LogUserRowid, DiagnosType, DiagnosStatus, MRDIADr,mradm);
			var SeccessFlag=ret.split('^')[0];
			if (SeccessFlag!="0"){
				alert(ret+":失败")
				return
			}
			var MRDiagnosRowid=ret.split('^')[1];
			var MRDiagnosRowidStr=ret.substr(ret.indexOf("^")+1,ret.length);
			DoAfterInserMR(MRDiagnosRowidStr,DiagnosValue);
			$.messager.show({
				title:'消息',
				msg:'诊断插入成功',
				timeout:5000,
				showType:'slide'
			});
		}
		
	}
}
function DeleteMRDiagnos(MRDiagnosRowid) {
  var row = DiagnosListDataGrid.datagrid('getSelected');
  if (row) {
	  var MRDiagnosDesc=row.DiagnosDesc
	  var MRDiagnosNote=row.DiagnosMRDesc
	  if((MRDiagnosDesc=="")&&(MRDiagnosNote!="")){
		  MRDiagnosDesc=MRDiagnosNote
	  }
	  if((MRDiagnosDesc!="")&&(MRDiagnosNote!="")){
		  MRDiagnosDesc=MRDiagnosDesc+"("+MRDiagnosNote+")"
	  }else{
		  MRDiagnosDesc=MRDiagnosDesc
	  }
	  MRDiagnosDesc=MRDiagnosDesc.replace(/\&nbsp/g,"")
	  var DelMRDiagnosMessage = window.confirm('是否删除 ' + MRDiagnosDesc);
	  if (DelMRDiagnosMessage == false) {
		  return false;
	  };
  }
  var ret = cspRunServerMethod(DeleteMRDiagnosMethod, MRDiagnosRowid);
  if (ret != '0') {
    if(ret=='Discharged'){
	  $.messager.alert("提示","由于病人已出院,诊断不能删除");
	  return false;
  	}else if(ret=='Timeout'){
	  $.messager.alert("提示","您不能删病人以前诊断");
	  return false;
  	}else{
	  $.messager.alert("提示","删除失败");	
	  return false;
	}
  }else {
	  var row = DiagnosListDataGrid.datagrid('getSelected');
      var index = DiagnosListDataGrid.datagrid('getRowIndex', row);
	  if (index!="") {
		 DiagnosListDataGrid.datagrid('deleteRow',index);
	 }
	 /*if (DiagnosListSelectedRow!="") {
		 DiagnosListDataGrid.datagrid('deleteRow',DiagnosListSelectedRow);
	 }*/
	 LoadDiagnosListDataGrid();
	 LoadDiagnosHistoryDataGrid();
	 SaveMRDiagnosToEMR()
  }

}
function CheckBeforeUpdate(MRCICDRowid){
	if(!CheckIsAdmissions(EpisodeID)) return false;	 
	if (!CheckBeforeInsertMRDiag()) return false;
	if (MRCICDRowid==WeekGestationDia){
		$('#DiagnosSearch').combogrid('setValue','');
		SelMRCICDRowid="";
		ShowLMPWindow();
		return false;		 
	}
	if ((MRCICDRowid!=null)||(MRCICDRowid!="")) {
		var Str=MarchDiagnosis(MRCICDRowid);
		if (Str==1){
			var vaild = window.confirm("所加诊断在本次诊断中已经存在，请确认是否重复增加");
			if(!vaild) {
				$('#DiagnosSearch').combogrid("clear");
				SelMRCICDRowid="";
				return false;
			}
		}
	}
    if (((MRCICDRowid!="")&&(MRCICDRowid!=null))&&(GetSeriousDiseaseByICDMethod!="")){
	    var SeriousDisease=cspRunServerMethod(GetSeriousDiseaseByICDMethod,MRCICDRowid);
	    if (SeriousDisease=="Y") $.messager.alert("提示","此诊断为传染病诊断,请注意及时上报.","info");
	}
	return true;
}
function CheckSyndromeListInfo(){
	var SyndromeCICDStr="";
	var SyndromeCDescStr="";
	var repeatFlag=0;
	var DiagnosCat=$('input:radio[name="DiagnosCat"]:checked').val();
	if ((UserICDSyndrome!="1")||(DiagnosCat=="0")){return String.fromCharCode(1);}
	$("input[id^='SyndromeSearch']").each(function(i){
		var ICDRowID=$(this).combogrid("options").value;
		var ICDDesc=$(this).next('span').find('input').val();
		var tmpICDDesc=ICDDesc;
		if ((ICDRowID=="")&&(ICDDesc!="")){
			ICDDesc=ICDDesc+"#3";
		}else{
			ICDDesc="";
		}
		if ((ICDRowID!="")||(ICDDesc!="")){
			if (ICDRowID!=""){
				if (("^"+SyndromeCICDStr+"^").indexOf("^"+ICDRowID+"^")>=0){
					alert(tmpICDDesc+"记录重复!")
					repeatFlag=1;
				}
			}else{
				if (("^"+SyndromeCDescStr+"^").indexOf("^"+ICDDesc+"^")>=0){
					alert(tmpICDDesc+"记录重复!")
					repeatFlag=1;
				}
			}
			if ((SyndromeCICDStr=="")&&(SyndromeCDescStr=="")){
				SyndromeCICDStr=ICDRowID;
				SyndromeCDescStr=ICDDesc;
			}else{
				SyndromeCICDStr=SyndromeCICDStr+"^"+ICDRowID;
				SyndromeCDescStr=SyndromeCDescStr+"^"+ICDDesc;
			}
		}
		
	});
	if (repeatFlag=="1") return false
	return true;
}
function InsertMRDiagnos(MRCICDRowid,SyndromeInfo) {
	var ret=CheckSyndromeListInfo();
	debugger;
	if (!ret) return false;
	DiagnosListDataGrid.datagrid("unselectAll");
	//非ICD保存
	var MRDIADesc=$("#DiagnosNotes").val()
    if ((MRCICDRowid==null)||(MRCICDRowid=="")) {
	    if(window.confirm("是否确定录入非标准ICD诊断?")){
		    if (!CheckBeforeUpdate(MRCICDRowid)) return false;
		    MRDIADesc=MRDIADesc.replace(/[\\\@\#\$\%\^\&\*\{\}\:\"\<\>\?]/g,"");; //MRDIADesc.replace(/(^\s*)|(\s*$)/g,'');
			if(MRDIADesc==""){
			  var MRDIADesc = $('#DiagnosSearch').combogrid('getValue');
			}
			MRDIADesc=MRDIADesc.replace(/[\\\@\#\$\%\^\&\*\{\}\:\"\<\>\?]/g,"");
		    if (MRDIADesc=="")
	         {
		       $.messager.alert("提示","禁止录入描述为空的为空的非标准ICD诊断.","error")
		       return false;
	         }
	         if(!UpdateMrdiagNote(mradm,MRDIADesc)) return false;
		}else{
			$("#DiagnosNotes").val('');
			return false;
		}
	}
	//ICD诊断重复性判断
	if(MRCICDRowid!=""){
		if (UseDKBFlag==1){
			var RetStr = cspRunServerMethod(GetDiagTempData, MRCICDRowid);
			if (RetStr!=""){
				var RetStrArr=RetStr.split("^");
				var DKBBCRowId=RetStrArr[0]; //属性模板Id
				var emptyInfo=RetStrArr[1];
				//emptyInfo="糖尿病(分型,并发症)" //测试用
				if (emptyInfo=="") {
					
					return SaveMRDiagnos(DKBBCRowId,MRCICDRowid,MRDIADesc,SyndromeInfo);
			    }else{
				    DiagPropertyShowFlag=0;
				    ShowFormWindow(MRCICDRowid,"");
				}
		    }
	    }else{
		    SaveMRDiagnos("",MRCICDRowid,MRDIADesc,SyndromeInfo);
		}
	}else{
		SaveMRDiagnos("","",MRDIADesc,SyndromeInfo)
	}
	return true;
}
function SaveMRDiagnos(DKBBCRowId,MRCICDRowid,MRDIADesc,SyndromeInfo){
	if ((MRCICDRowid!=null)&&(MRCICDRowid!="")){
		if (!CheckBeforeUpdate(MRCICDRowid)) return false;
	}
	DiagnosStatus=GetDiagnosStatus();
	var paraMRCICDRowid=MRCICDRowid;
	var DiagnosRowId=$("#SelDiagRowId").val();
	if (DiagnosRowId==""){
		var DiagnosPropertyInfo="";
		if ((UseDKBFlag==1)||(DKBBCRowId!="")){
			var MRCICDRowid="" //$("#SelDiagRowId").val();
			/*var DiagFormData=GetDiagFormData();
			var DiagFormBaseInfo=DiagFormData.split("#")[0];
			var DiagnosPropertyInfo=DiagFormData.split("#")[1];
			var DiagStatus=DiagFormBaseInfo.split("^")[0];
			var Form_MRDiagType=DiagFormBaseInfo.split("^")[1];*/
			var DiagnosPropertyInfo=GetDiagFormData();
			if (typeof DiagnosPropertyInfo=="boolean") return false;
			if (typeof DKBBCRowId !="undefined"){
				DiagnosPropertyInfo=DKBBCRowId+"^^^^";
		    }
		    if ((MRDIADesc=="")||(typeof DKBBCRowId =="undefined")){
			    var MRDIADesc=$("#DiagnosNotes").val()
		    	MRDIADesc=MRDIADesc.replace(/[\\\@\#\$\%\^\&\*\{\}\:\"\<\>\?]/g,"");
			}
	    }
		var LogDepRowid = session['LOGON.CTLOCID'];
		var LogUserRowid = session['LOGON.USERID'];
		var MRADMID = mradm;
		var DiagnosTypeId=$("#MRDiagType").combobox("getValue");
		var DiagnosLevel=1;
		var MainDiaType="N";
		if ($("#MainDiaType").is(":checked")) {MainDiaType="Y";}else{MainDiaType="N";}
		if (typeof SyndromeInfo !="undefined"){
			var SyndromeCICDStr=SyndromeInfo.split("#")[0];
			var SyndromeCDescStr=SyndromeInfo.split("#")[1];
			SyndromeCICDStr=SyndromeCICDStr.replace(/(\!)/g,"^")
			SyndromeCDescStr=SyndromeCDescStr.replace(/(\!)/g,"^")
		}else{
			var SyndromeInfo=GetSyndromeListInfo();
			var SyndromeCICDStr=SyndromeInfo.split(String.fromCharCode(1))[0];
			var SyndromeCDescStr=SyndromeInfo.split(String.fromCharCode(1))[1];
		}
		if ((SyndromeCICDStr!="")&&(!CheckDiagIsEnabled(SyndromeCICDStr))) return false;
		if (typeof MRDIADesc =="undefined"){
			var MRDIADesc=$("#DiagnosNotes").val()
			MRDIADesc=MRDIADesc.replace(/[\\\@\#\$\%\^\&\*\{\}\:\"\<\>\?]/g,""); //MRDIADesc.replace(/(^\s*)|(\s*$)/g,'');
			/*if(MRDIADesc==""){
				MRDIADesc = $('#DiagnosSearch').combogrid('getValue');
			}
		    MRDIADesc=MRDIADesc.replace(/[\\\@\#\$\%\^\&\*\(\)\{\}\:\"\<\>\?\[\]]/g,"")*/
		}else{
			//DiagnosPropertyInfo="";
		}
		if ((DiagnosPropertyInfo!="")&&(DiagnosPropertyInfo.split("^")[0]!="")) MRCICDRowid="";
		else  MRCICDRowid=paraMRCICDRowid,DiagnosPropertyInfo=""
		if (MRDIADesc!="") {
			var ICDType=$('input:radio[name="DiagnosCat"]:checked').val();
			ICDType=parseInt(ICDType)+1;
			MRDIADesc=MRDIADesc+"#"+ICDType;
		}
		var ret = cspRunServerMethod(InsertMRDiagnosMethod, LogDepRowid, MRADMID, MRCICDRowid, LogUserRowid, MRDIADesc, DiagnosTypeId,"","","","","",DiagnosStatus,DiagnosLevel,"",MainDiaType,SyndromeCICDStr,SyndromeCDescStr,DiagnosPropertyInfo);
		var SeccessFlag=ret.split('^')[0];
		if (SeccessFlag!='0') {
			var ErrorMsg=ret.split('^')[1];
			$.messager.alert("提示","插入诊断失败,"+ErrorMsg,"error");
			return false;
		}
		findCondition="";
		DiagPropertyShowFlag=1;
		var MRDiagnosRowid=ret.split('^')[1];
		var MRDiagnosRowidStr=ret.substr(ret.indexOf("^")+1,ret.length);
		DoAfterInserMR(MRDiagnosRowidStr,MRCICDRowid)
		//更新发病日期
		var OnsetDate=$("#IDate").datebox("getValue"); 
		var ret=cspRunServerMethod(UpdateOnsetDateMethod,MRDiagnosRowid,OnsetDate)
		if (MRCICDRowid!=""){
			if (window.dialogArguments==undefined){
				var ZYFlag=cspRunServerMethod(GetZYMRDiagnosFlag, MRDiagnosRowid)
			    if((ZYFlag=="Y")&&(UserICDSyndrome!="1")){
				    var vaild = window.confirm("是否添加证型?");
					if(vaild) {
						DiagnosZXShow(MRDiagnosRowid);
					}
			    }
	        }
		}
		//插入诊断界面其他录入信息
		InsertOtherInfo(false);
		return true;
	}else{
		//DiagnosStatus
		var DiagnosPropertyInfo=GetDiagFormData();
		var DiagBaseInfo=GetDiagBaseInfo()
		var ret=tkMakeServerCall("web.DHCMRDiagnos","SaveDiagProperty",DiagnosRowId,DiagnosPropertyInfo,session['LOGON.USERID'],DiagBaseInfo);
		if (ret=="0"){
			$.messager.alert("提示","修改诊断属性成功!");
			LoadDiagnosListDataGrid();
			LoadDiagnosHistoryDataGrid();
			return true;
		}else{
			$.messager.alert("提示","修改诊断属性失败!","error");
		}
		$("#SelDiagRowId").val("");
	}
	return true;
	
}
function UpdateArriveStatus() {
    var LogonUserID = session['LOGON.USERID']
    if (cspRunServerMethod(SetArrivedStatus, EpisodeID, DocID, session['LOGON.CTLOCID'], session['LOGON.USERID']) != '1') {}
}
function UpdateMrdiagNote(MRDiagnosNoteId, DiagnosNotechangevalue,DiagPRowId) {
	if (typeof DiagPRowId =="undefined"){
		DiagPRowId="";
	}
	var FlagDiagnosNote=0;
	var icd=""
	if (DiagPRowId==""){
		//对产生变动的诊断查看是否是标准icd
		if(MRDiagnosNoteId!="") icd = cspRunServerMethod(FindMRDIAICDCodeDR,MRDiagnosNoteId);
		if ((icd=="")&&(DiagnosNotechangevalue=="")){
			var vaild=$.messager.alert("提示","录入了为空的非标准icd诊断,!","error");
			return false;
		}
	}
	//加入对非标准icd诊断录入时候是否重复的判断
	var ret = cspRunServerMethod(GetMRDiagnoseList, mradm, '');
	if (ret != '') {
		var retarry = ret.split(String.fromCharCode(1));
		for (i = 0; i < retarry.length; i++) {
			var retItemArry = retarry[i].split('^');
			var id=retItemArry[1];
            var DiagnosICDCode = retItemArry[4];
            var DiagnosNote = retItemArry[6];
            if ((DiagnosICDCode=="")&&(DiagnosNote!="")&&(DiagnosNotechangevalue!="")&&(MRDiagnosNoteId!=id)){
	             var Str1=trim(DiagnosNote);
				 var Str2=trim(DiagnosNotechangevalue);
				 if((Str1==Str2)&&(Str1!="")&&(Str2!=""))  FlagDiagnosNote=1
				 if (icd!=""){
					 var FlagDiagnosNote=0
			     }
			     
	        }
		}
	}
	var Note = DiagnosNotechangevalue;
	if(FlagDiagnosNote==1){
		if(!window.confirm('非标准icd诊断注释重复,是否确定添加?')){
			return false;
		}
	}
	var ret = cspRunServerMethod(UpdateMRDiagnosNote, MRDiagnosNoteId, Note);
	if(ret==""){
	   //重新加载本次诊断数据
	   LoadDiagnosListDataGrid();
	   
	} 
	return true;
}
//AlertFlag 8.0测试库入参
function InsertOtherInfo(AlertFlag){
	var DiagnosValue=1
	var Admway="",ILI=""
	if ($("#ReAdmis").is(":checked")) {ReAdmis="R";Admway="MZFZ";}else{ReAdmis="";}
	if ($("#FirstAdm").is(":checked")) {FirstAdm="F";Admway="CZ"}else{FirstAdm="";}
	if ($("#OutReAdm").is(":checked")) {OutReAdm="R";Admway="CYFZ";}else{OutReAdm="";}
	if ($("#TransAdm").is(":checked")) {TransAdm="Y";Admway="ZZ"}else{TransAdm="";}
	if ($("#ILI").is(":checked")) {ILI="Y"}
	//收缩压
	var BPSystolic=$("#BPSystolic").val();
	//舒张压
	var BPDiastolic=$("#BPDiastolic").val();
	var r = /^[0-9]*[1-9][0-9]*$/ 
	if ((BPSystolic!="")&&(!r.test(BPSystolic))){
		alert("收缩压只能录入数字!");
		// $.messager.alert("提示","收缩压只能录入数字!",function(){
			 $("#BPSystolic").focus();
		 //});
		 return false;
	}
	if ((BPDiastolic!="")&&(!r.test(BPDiastolic))){
		alert("舒张压只能录入数字!")
		//$.messager.alert("提示","舒张压只能录入数字!",function(){
			 $("#BPDiastolic").focus();
	    //});
		 return false;
	}
	var Weight=$("#Weight").val();
	var Specialist=GetSaveSpecialList(); //特殊人群
	var Subject=""
	var AdmPara=ReAdmis+"^"+Specialist+"^"+Subject+"^"+Weight+"^"+FirstAdm+"^"+OutReAdm+"^"+TransAdm+"^"+ILI+"^"+DiagnosValue+"^"+Admway+"^"+BPSystolic+"^"+BPDiastolic;
	var ret=cspRunServerMethod(UpdatePAADM,EpisodeID,AdmPara,"Hidden","Hidden")
	if ((AlertFlag==true)&&(ret=="0")) {
		//成功后自动插入到诊断记录列表,无需提示.	
		$.messager.show({title:"提示",msg:"保存成功"});
	}
}
function CheckBeforeInsertMRDiag()
{
	if (DiagPropertyShowFlag=="1"){
		var DiagnosTypeDesc=$("#MRDiagType").combobox("getText");
		var DiagnosType=$('#MRDiagType').combobox("getValue");
		if((DiagnosType=="")||(DiagnosTypeDesc=="")){
			$.messager.alert("提示", "请选择诊断类型！", "error");
			return false;
		}
		var BPSystolic=$("#BPSystolic").val().replace(/(^\s*)|(\s*$)/g,'');	
		var BPDiastolic=$("#BPDiastolic").val().replace(/(^\s*)|(\s*$)/g,'');
		if (NeedStolicMast==1){
			if ((BPSystolic=="")||(BPDiastolic=="")){
				$.messager.alert("提示","请录入完整的血压！","error");
				return false;
			}
		}
		var r = /^[0-9]*[1-9][0-9]*$/ 
		if ((BPSystolic!="")&&(!r.test(BPSystolic))){
			alert("收缩压只能录入数字!");
			// $.messager.alert("提示","收缩压只能录入数字!",function(){
				 $("#BPSystolic").focus();
			 //});
			 return false;
		}
		if ((BPDiastolic!="")&&(!r.test(BPDiastolic))){
			alert("舒张压只能录入数字!")
			//$.messager.alert("提示","舒张压只能录入数字!",function(){
				 $("#BPDiastolic").focus();
		    //});
			 return false;
		}
	}
	var OnsetDate=$("#IDate").datebox("getValue"); 
	if(OnsetDate==""){
		$.messager.alert("提示", "请选择发病日期！", "error");
		return false;
	}else{
		var sd=OnsetDate.split("-");
        var IDateCompare = new Date(sd[0],sd[1]-1,sd[2]);
        var TodayDate=new Date()
        if (IDateCompare>TodayDate){
	      $.messager.alert("提示", "发病日期大于今天日期，请重新选择！", "error");
	      return false; 
	    }
	}
	var CheckAddret=cspRunServerMethod(CheckAdd,EpisodeID);
	if (CheckAddret!=""){
	   if(CheckAddret=='Discharged'){
		   $.messager.alert("提示","由于病人已出院,不能增加新诊断", "error");
	       return false;
	   }else if(CheckAddret=='Cancel'){
		   $.messager.alert("提示","由于病人已经退院，不能增加新诊断", "error");
	       return false;
  	   }else if(CheckAddret=="OPCancel"){
	  	   $.messager.alert("提示","由于病人已经退号，不能增加新诊断", "error");
	       return false;
	  }
	}
	
	var ret = cspRunServerMethod(InsuPatTypeCheck, EpisodeID);
	if (ret==1){
		var bln = window.confirm("请先核对是否是医保病人,谢谢!");
		if (bln==false){return;}   
	}
	return true;
}
///查询诊断模板明细
function InitMRDiagTemplateDetail()
{
	MRDiagTemplateDetailColumns=[[    
                    { field: 'DHCMRDiaICDICDDR', title: '', width: 1, align: 'center', sortable: true,hidden:true
					}, 
					{ field: 'DHCMRDiaICDICDDesc', title:'诊断描述', width: 200, align: 'center', sortable: true
					} 
    			 ]];
	MRDiagTemplateDetailDataGrid=$('#tabMRDiagTemplateDetail').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //为true时 不显示横向滚动条
		autoRowHeight : false,
		//url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"DHCMRDiaICDICDDR",
		pageList : [15,50,100,200],
		columns :MRDiagTemplateDetailColumns,
		method:'get', 
		onClickRow:function(rowIndex, rowData){
		},
		onDblClickRow:function(rowIndex, rowData){
			var MRCICDRowidStr=rowData.DHCMRDiaICDICDDR
			var DHCMRDiaICDICDDesc=rowData.DHCMRDiaICDICDDesc
			var SyndromeInfo=""
			var MRCICDRowidStrArr=MRCICDRowidStr.split("*");
			var MRCICDRowid=MRCICDRowidStrArr[0];
			var MRCICDDesc=DHCMRDiaICDICDDesc.split("*")[0];
			if (MRCICDRowidStrArr.length>1){
				var SyndromeInfo=MRCICDRowidStrArr[1];
				SyndromeCICDStr=SyndromeInfo.split("#")[0];
				SyndromeCDescStr=SyndromeInfo.split("#")[1];
			}
			if(!CheckDiagIsEnabled(MRCICDRowidStr)){
				return false;
			}
			if ((MRCICDRowid=="")&&(MRCICDDesc!="")){
				$("#DiagnosNotes").val(MRCICDDesc)
			}
			//alert(MRCICDRowid+"@"+SyndromeInfo);
			InsertMRDiagnos(MRCICDRowid,SyndromeInfo);
			
		},
        onLoadSuccess:function(data){ 
            MRDiagTemplateDetailDataGrid.datagrid("unselectAll");		
		}
	});
	//LoadMRDiagTemplateDetailDataGrid();
}
function LoadMRDiagTemplateDetailDataGrid()
{
	var DiagTemplateId=$("#MRDiagTemplate").combobox("getValue")
	if(DiagTemplateId=="--请选择模板--") DiagTemplateId="";
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCMRDiagnosNew';
	queryParams.QueryName ='DiagTemplateDetailList';
	queryParams.Arg1 =DiagTemplateId;
	queryParams.ArgCnt =1;
	var opts = MRDiagTemplateDetailDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	MRDiagTemplateDetailDataGrid.datagrid('load', queryParams);
}
function HisMRDiagRepClick(ICDRowid,MRDIADr)
{
	if (ICDRowid==""){
		$.messager.alert("提示","只支持查看ICD或诊断知识库诊断重复记录!");
		return false;
	}
	if (window.dialogArguments!=undefined){
		$.messager.alert("提示","模态窗口不支持,请到对应功能菜单下处理!");
		return false;
    }
	if (ICDRowid!="") {
	   //得到这个ICDRowid的重复记录
	   var repUrl="websys.default.csp?WEBSYS.TCOMPONENT=DHCHisMRDiagRep&PatientID="+PatientID+"&ICDCodeRowId="+ICDRowid+"&MRDIADr="+MRDIADr;
	   window.open(repUrl,"_blank","height=600,width=600,left=50,top=50,status=yes,toolbar=no,menubar=no,location=no")
	}
}
function MydiagnosEditshow() {
  url = "websys.default.csp?WEBSYS.TCOMPONENT=DHCMRDiagnosEdit"
  websys_createWindow(url, true, "status=1,scrollbars=1,top=0,left=0,width=1200,height=700")
}
function myformatter(date){
	var y = date.getFullYear();
	var m = date.getMonth()+1;
	var d = date.getDate();
	if (DateDefaultFormat==3) return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
	else if (DateDefaultFormat==4) return (d<10?('0'+d):d)+"/"+(m<10?('0'+m):m)+"/"+y
	else return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
}
function myparser(s){
    if (!s) return new Date();
    if(DateDefaultFormat==4){
		var ss = s.split('/');
		var y = parseInt(ss[2],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[0],10);
	}else{
		var ss = s.split('-');
		var y = parseInt(ss[0],10);
		var m = parseInt(ss[1],10);
		var d = parseInt(ss[2],10);
	}
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
}
function DiagnosSearch()
{
}
function trim(str)
{
	return str.replace(/[\t\n\r ]/g, "");
}
//返会诊断是否重复标识
function MarchDiagnosis(DiagnosValue)
{
      var Str=cspRunServerMethod(FlagMarchDiagnose,mradm,DiagnosValue);
      return Str;
}
function ReSetWindowData()
{
	//诊断保存成功 诊断注释赋值为空
	$("#DiagnosNotes").val("")
	$('#DiagnosSearch').combogrid('setValue','');
	$("input[id^='SyndromeSearch']").each(function(i){
		$(this).combogrid('setValue','');
	});
	
	InitMRDiagType("MRDiagType");
	$("#MainDiaType").attr({checked:false})
}
function AdjustMRDiagnosLevel(Row,Direction){
    //得到rows对象
    var rows = DiagnosListDataGrid.datagrid("getRows");
	var row = DiagnosListDataGrid.datagrid('getSelected');
    var index = DiagnosListDataGrid.datagrid('getRowIndex', row);
	var DiagnosDesc=rows[index].DiagnosDesc
    var Level=rows[index].DiagnosLeavel
    var Level=parseInt(+Level)+parseInt(Direction);
    var SpaceHTML="&nbsp"
    if(Direction==1){
	    rows[index].DiagnosDesc=SpaceHTML+DiagnosDesc
	}else{
		rows[index].DiagnosDesc=DiagnosDesc.replace('&nbsp', '');
	}
	if(Level<=1) Level=1
    // 对某个单元格赋值
    rows[index].DiagnosLeavel=Level   
    //  刷新该行, 只有刷新了才有效果
    DiagnosListDataGrid.datagrid('refreshRow', index);
	BSaveclickhandler();
    /*var DiagnosDesc=rows[DiagnosListSelectedRow].DiagnosDesc
    var Level=rows[DiagnosListSelectedRow].DiagnosLeavel
    var Level=parseInt(Level)+parseInt(Direction);
    var SpaceHTML="&nbsp"
    if(Direction==1){
	    rows[DiagnosListSelectedRow].DiagnosDesc=SpaceHTML+DiagnosDesc
	}else{
		rows[DiagnosListSelectedRow].DiagnosDesc=DiagnosDesc.replace('&nbsp', '');
	}
	if(Level<=1) Level=1
    // 对某个单元格赋值
    rows[DiagnosListSelectedRow].DiagnosLeavel=Level   
    //  刷新该行, 只有刷新了才有效果
    DiagnosListDataGrid.datagrid('refreshRow', DiagnosListSelectedRow);
	BSaveclickhandler();*/
}
function BSaveclickhandler()  {
	//得到rows对象
    var rows = DiagnosListDataGrid.datagrid("getRows"); 
    for (var i=0;i<rows.length;i++) {
	    var MRDiagnosRowId=rows[i].DiagnosValue
        var MRDiagnosLevel=rows[i].DiagnosLeavel
	    var MRDiagnosSequence=parseInt(i)+1;
	    var info=MRDiagnosLevel+"^"+MRDiagnosSequence
	    ret = cspRunServerMethod(UpdateMRDiagnosMethod, MRDiagnosRowId, info)
    }
}
function BMoveUpclickhandler(Position)
{
	if (typeof Position =="undefined"){
		Position="up"
    }
	var row = DiagnosListDataGrid.datagrid('getSelected'); 
    var index = DiagnosListDataGrid.datagrid('getRowIndex', row);
    mysort(index, Position);
    BSaveclickhandler();
}
/*
function BMoveDownclickhandler()
{
	var row = DiagnosListDataGrid.datagrid('getSelected');
    var index = DiagnosListDataGrid.datagrid('getRowIndex', row);
    mysort(index, 'down');
    BSaveclickhandler();
}
function mysort(index, type) {

    if ("up" == type) {
        if (index != 0) {
            var toup = DiagnosListDataGrid.datagrid('getData').rows[index];
            var todown = DiagnosListDataGrid.datagrid('getData').rows[index - 1];
            DiagnosListDataGrid.datagrid('getData').rows[index] = todown;
            DiagnosListDataGrid.datagrid('getData').rows[index - 1] = toup;
            DiagnosListDataGrid.datagrid('refreshRow', index);
            DiagnosListDataGrid.datagrid('refreshRow', index - 1);
            DiagnosListDataGrid.datagrid('selectRow', index - 1);
        }
    } else if ("down" == type) {
        var rows = DiagnosListDataGrid.datagrid('getRows').length;
        if (index != rows - 1) {
            var todown = DiagnosListDataGrid.datagrid('getData').rows[index];
            var toup = DiagnosListDataGrid.datagrid('getData').rows[index + 1];
            DiagnosListDataGrid.datagrid('getData').rows[index + 1] = todown;
            DiagnosListDataGrid.datagrid('getData').rows[index] = toup;
            DiagnosListDataGrid.datagrid('refreshRow', index);
            DiagnosListDataGrid.datagrid('refreshRow', index + 1);
            DiagnosListDataGrid.datagrid('selectRow', index + 1);
        }
    }
}
*/
function BMoveUpclickhandler(Position)
{
	var row = DiagnosListDataGrid.datagrid('getSelected'); 
    var index = DiagnosListDataGrid.datagrid('getRowIndex', row);
    var MainMRDIADr=row.MRDIAMRDIADR
    if (MainMRDIADr!=""){
	    alert("请调整主诊断")
		return false   
	}
    mysort(index, Position);
    BSaveclickhandler();
}
function BMoveDownclickhandler(Position)
{
	var row = DiagnosListDataGrid.datagrid('getSelected');
    var index = DiagnosListDataGrid.datagrid('getRowIndex', row);
    var MainMRDIADr=row.MRDIAMRDIADR
    if (MainMRDIADr!=""){
	    alert("请调整主诊断")
		return false   
	}
    mysort(index, Position);
    BSaveclickhandler();
}
function mysort(index, type) {
    var rows = DiagnosListDataGrid.datagrid('getRows').length;
    if (("up" == type)||("Top" == type)) {
        if (index != 0) {
			///存在关联医嘱的问题，上下移动时判断关联诊断
			var toupLinkDiaList=GetLinkDiaNum(index)
			if ("Top" == type){
				var todownLinkDiaList=index //GetLinkDiaNum(0);
				var todownLinkDiaNum=index;
			}else{
				var todownLinkDiaList=GetLinkDiaNum(index - 1);
				var todownLinkDiaNum=todownLinkDiaList.split("^").length
			}
			var toupLinkDiaNum=toupLinkDiaList.split("^").length
			var StartIndex=index-todownLinkDiaNum
			var CopyRows=new Array(toupLinkDiaNum+todownLinkDiaNum)
			for (var i=0;i<CopyRows.length;i++) {
				if (i<toupLinkDiaNum){
					CopyRows[i]=DiagnosListDataGrid.datagrid('getData').rows[index+i]
				}else{
					CopyRows[i]=DiagnosListDataGrid.datagrid('getData').rows[StartIndex+i-toupLinkDiaNum]
				}
				
			}
			for (var i=0;i<CopyRows.length;i++) {
				DiagnosListDataGrid.datagrid('getData').rows[StartIndex+i]=CopyRows[i]
				DiagnosListDataGrid.datagrid('refreshRow', StartIndex+i)
				
			}
			DiagnosListDataGrid.datagrid('selectRow', StartIndex);
        }
    } else if (("down" == type)||("Bottom" == type)) {
        if (index != rows - 1) {
	        ///存在关联医嘱的问题，上下移动时判断关联诊断
			var todownLinkDiaList=GetLinkDiaNum(index)
			var todownLinkDiaNum=todownLinkDiaList.split("^").length
			if ("Bottom" == type){
				var toupLinkDiaList=rows-todownLinkDiaNum-index;
			    var toupLinkDiaNum=rows-todownLinkDiaNum-index;
			}else{
				var toupLinkDiaList=GetLinkDiaNum(index + todownLinkDiaNum);
			    var toupLinkDiaNum=toupLinkDiaList.split("^").length;
			}
			var StartIndex=index
			var CopyRows=new Array(toupLinkDiaNum+todownLinkDiaNum)
			for (var i=0;i<CopyRows.length;i++) {
				if (i<toupLinkDiaNum){
					CopyRows[i]=DiagnosListDataGrid.datagrid('getData').rows[StartIndex+todownLinkDiaNum+i]
				}else{
					CopyRows[i]=DiagnosListDataGrid.datagrid('getData').rows[StartIndex+i-toupLinkDiaNum]
				}
				
			}
			for (var i=0;i<CopyRows.length;i++) {
				DiagnosListDataGrid.datagrid('getData').rows[StartIndex+i]=CopyRows[i]
				DiagnosListDataGrid.datagrid('refreshRow', StartIndex+i)
				
			}
			DiagnosListDataGrid.datagrid('selectRow', StartIndex+toupLinkDiaNum);
        }
    }
}
function GetLinkDiaNum(index){
	var RowList=""
	var rows = DiagnosListDataGrid.datagrid("getRows"); 
	var MainMRDIADr=DiagnosListDataGrid.datagrid('getData').rows[index].MRDIAMRDIADR;
	var DiagnosValue=DiagnosListDataGrid.datagrid('getData').rows[index].DiagnosValue;
    for (var i=0;i<rows.length;i++) {
	    var TmpRowID=rows[i].DiagnosValue
        var TmpMain=rows[i].MRDIAMRDIADR
        if (index==i){
        	//continue
        }
        if ((MainMRDIADr=="")&&(DiagnosValue==TmpMain)||
        	((MainMRDIADr!="")&&((TmpMain!="")&&(TmpMain==MainMRDIADr)||(MainMRDIADr==TmpRowID))||
        	(DiagnosValue==TmpRowID))
        ){
	    	if (RowList==""){
		    	RowList=i+""
		    }else{
				RowList=RowList+"^"+i
			}   
	    }
    }
    RowList=RowList
	return RowList
}

function DiagnosCatChange()
{
	SelMRCICDRowid="";
	$('#DiagnosSearch').combogrid("clear");
	RemoveSyndromeList();
	setTimeout(function() {
		$('#DiagnosSearch').next('span').find('input').focus();
		window.returnValue=false;
		if ($('input:radio[name="DiagnosCat"]:checked').val()=="0"){
			$("tr[id^='UserICDSyndromeTR']").each(function(i){
				$(this).css({visibility: 'hidden'});
			})
		}else{
			$("tr[id^='UserICDSyndromeTR']").each(function(i){
				$(this).css({visibility: 'visible'});
			})
		}
	},50)
	
}
//证型选择查看
function DiagnosZXShow(DiagnosDr)
{
	if (window.dialogArguments!=undefined){
		$.messager.alert("提示","模态窗口不支持,请到对应功能菜单下处理!");
		return false;
    }
	if(DiagnosDr=="") return false;
	var url ="websys.default.csp?WEBSYS.TCOMPONENT=DHCDocDiagnosSyndSelect&Adm="+EpisodeID+"&MRDiagnoeRowId="+DiagnosDr+"&CTLoc="+session['LOGON.CTLOCID'];
	var winName="newWin";       
	var awidth=screen.availWidth/6*2;      
	var aheight=screen.availHeight/5*2;       
	var atop=(screen.availHeight - aheight)/2;   
	var aleft=(screen.availWidth - awidth)/2;  
	var param0="scrollbars=1,status=0,menubar=1,resizable=no,location=0";
	var params="top=" + atop + ",left=" + aleft + ",width=" + awidth + ",height=" + aheight + "," + param0 ;  
	win=window.open(url,winName,params); 
	win.focus();
	
}
function CreaterSpecial()
{
	//初始化List
		$('#Special').combo({
		required:false,
		editable:false,
		panelWidth:150,
		multiple:true,
		panelHeight:250,
		onHidePanel:(function(){
				var Str=GetSpecialList().split(String.fromCharCode(1))
				var s= Str[0].split("^").join(",");
				$('#Special').combo('setValue', Str[1]).combo('setText', s);
				if (s!="") tooltipSpecialP(s);
			})
		});
		$('#sp').appendTo($('#Special').combo('panel'));
		$('#sp input').click(function(){
			var v = $(this).val();
			//选择确定按钮为空
			if (v=="确定"){
				$('#Special').combo('hidePanel');
			}
		});
	   //list初始化选择值
	   SetSpecialList(SpecialStrCreat)
}
//设置说明值
function tooltipSpecialP(s){
	$("#SpecialPlist").tooltip(
	{   	position: 'bottom',    
			content:s,
			trackMouse: true,
			title:'内容',
		  	deltaX:100,
		  	deltaY:0,
		  	onShow: function(){ 
			$(this).tooltip('tip').css({          
			   backgroundColor: '#FFFFFF',           
			   borderColor: '#99FFFF'
			  }); 
		 }}
		 );
	
}
//设置初始化
function SetSpecialList(SetStr)
{
	var SpecialStr=""
	var SpecialValue=""
	var SpecialLen=$('#sp input').length;
	for(var i=0;i<SpecialLen;i++)
	{
		var Check=$('#sp input')[i].checked;
		var val=$('#sp input')[i].value;
		if (val=="Sure"){continue}
		if (val!=""){
				if (("^"+SetStr+"^").indexOf("^"+val+"^")>=0){$('#sp input')[i].checked=true }
	    }
	}
	var Str=GetSpecialList().split(String.fromCharCode(1))
	var s= Str[0].split("^").join(",");
	$('#Special').combo('setValue', Str[1]).combo('setText', s).combo('hidePanel');
	if (s!="") tooltipSpecialP(s);
	return true
}

///获取下拉选择串
function GetSpecialList()
{
	var SpecialStr=""
	var SpecialValue=""
	var SpecialLen=$('#sp input').length;
	for(var i=0;i<SpecialLen;i++)
	{
		var Check=$('#sp input')[i].checked;
		if (Check){
			var str = $('#sp span')[i].innerText; //描述
			//var str=(i+1)
			var val=$('#sp input')[i].value
			if (SpecialValue==""){SpecialStr=str;SpecialValue=val}
			else {SpecialStr=SpecialStr+"^"+str;SpecialValue=SpecialValue+val}
		}
		
	}
	return SpecialStr+String.fromCharCode(1)+SpecialValue;
}
///获取保存数据
function GetSaveSpecialList()
{
	var SaveSpecialStr=""
	var Obj=document.getElementById("Special");
	if (Obj){
		var SpecialLen=$('#sp input').length;
		for(var i=0;i<SpecialLen;i++)
		{
			var Check=$('#sp input')[i].checked;
			if (Check){
				var str = $('#sp span')[i].innerText; //描述
				var val=$('#sp input')[i].value;
				if (SaveSpecialStr==""){SaveSpecialStr=val+String.fromCharCode(1)+str;}
				else{SaveSpecialStr=SaveSpecialStr+"!"+val+String.fromCharCode(1)+str;}
			}
		
		}
	}
	return SaveSpecialStr
}
/*function SearchDiagnosList(value,name)
{
	$("#dialog1-form").css('display',''); 
	DiagnosSearchListColumns=[[    
                    { field: '诊断', title: 'desc', width: 50, align: 'center', sortable: true
					}, 
					{ field: 'Code', title:'code', width: 30, align: 'center', sortable: true
					} 
    			 ]];
	DiagnosSearchListDataGrid=$('#tabDiagnosSearchList').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false, //为true时 不显示横向滚动条
		autoRowHeight : false,
		url : PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"Code",
		pageList : [15,50,100,200],
		columns :DiagnosSearchListColumns,
		method:'get', 
		onClickRow:function(rowIndex, rowData){
		},
		onDblClickRow:function(rowIndex, rowData){
			
		}

	});
	LoadDiagnosSearchListDataGrid(value,name);
}
function LoadDiagnosSearchListDataGrid(value,name)
{
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCMRDiagnos';
	queryParams.QueryName ='LookUpWithAlias';
	queryParams.Arg1 ="gm";
	queryParams.Arg2 ="";
	queryParams.Arg3 ="";
	queryParams.Arg4 ="";
	queryParams.Arg5 =1;
	queryParams.ArgCnt =5;
	var opts = DiagnosSearchListDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	DiagnosSearchListDataGrid.datagrid('load', queryParams);
}*/

function cancelBubble() {
	if (window.event)
		window.event.cancelBubble=true;
	return false;
}
//判断是否可以接诊
function CheckIsAdmissions(EpisodeID) {
	if (EpisodeID=="") return false;
	var UserID=session['LOGON.USERID'];
	//var ret=tkMakeServerCall("web.DHCDocOutPatientList","CheckIsAdmissions",EpisodeID,UserID);
	var ret=cspRunServerMethod(CheckIsAdmissionsMethod,EpisodeID,UserID)
	if (ret!="") {
		$.messager.alert("提示","接诊失败,"+ret,"error");
		return false;
	}
	return true;
}
///保存诊断到电子病历
function SaveMRDiagnosToEMR(){
	if(EpisodeType=="I"){
		return true;
	}
	var ret=tkMakeServerCall("web.DHCDocDiagnosNew","GetMRDiagnosToEMR",EpisodeID) 
	//parent.updateEMRInstanceData("diag",ret)
	if (typeof(parent.invokeChartFun) === 'function') {
	    parent.invokeChartFun('门诊病历', 'updateEMRInstanceData', "diag", ret);
    }

}
//判断所录入诊断是否有效
function CheckDiagIsEnabled(MRCICDRowidStr){
	if(MRCICDRowidStr=="") return true;
	var MRCICDRowidStr=MRCICDRowidStr.replace(String.fromCharCode(2),"!")
	var reg=/(\*)|(\^)|(\:)|(\!)|(\-)|(\String.fromCharCode(2))/g;
	var MRCICDRowidStrArr=MRCICDRowidStr.replace(reg,"!").split("!")
	//var MRCICDRowidStrArr=MRCICDRowidStr.split(/-|:|,|^|!|*|/);
	for (var i=0;i<MRCICDRowidStrArr.length;i++) {
		var MRCICDRowid=MRCICDRowidStrArr[i];
		if (MRCICDRowid=="") {
			continue
		}
		var ret=tkMakeServerCall("web.DHCMRDiagnos","CheckICDIsEnabled",MRCICDRowid,EpisodeID) 
		if(ret!=""){
			alert(ret);
			//$.messager.alert("提示",ret,"error");
			return false;
		}
	}
	
	
	return true;
}

function AddSyndromeClickHandle(){
	 var SyndromeTRListobj=$("tr[id^='UserICDSyndromeTR']");
	 var Length=SyndromeTRListobj.length;
	 var NewIDExpand=Length+1;
	 $("#UserICDSyndromeTR_"+Length).after("<tr id='UserICDSyndromeTR_"+NewIDExpand+"'><td></td><td title='证型' class='easyui-tooltip'><input  type='text' id='SyndromeSearch_"+NewIDExpand+"' name='SyndromeSearch' /></td></tr>")
	 InitSyndromeComboGrid("SyndromeSearch_"+NewIDExpand);
}

function InitSyndromeComboGrid(idName)
{
	var fileview = $.extend({}, $.fn.datagrid.defaults.view, { 
	       onAfterRender: function (target) { ReSetFocusForSyn(idName); }
	       //,onBeforeRender:function (target, rows){ReSetSelect();} 
	});
	$('#'+idName).combogrid({
		panelWidth:500,
		panelHeight:435,
		delay: 0,    
		mode: 'remote', 
		view: fileview,   
		//url: "./dhcdoc.cure.query.combo.easyui.csp", 
		url:PUBLIC_CONSTANT.URL.QUERY_GRID_URL,
		fitColumns: true,   
		striped: true,   
		editable:true,   
		pagination : true,//是否分页   
		rownumbers:true,//序号   
		collapsible:false,//是否可折叠的   
		fit: true,//自动大小   
		pageSize: 15,//每页显示的记录条数，默认为10   
		pageList: [15],//可以设置每页记录条数的列表   
		method:'get', 
		idField: 'HIDDEN',    
		textField: 'desc',    
		columns: [[    
			{field:'desc',title:'诊断名称',width:400,sortable:true
			},
			{field:'code',title:'code',width:120,sortable:true},
			{field:'HIDDEN',title:'HIDDEN',width:120,sortable:true,hidden:true}
		]],
		keyHandler:{
			up: function () {
                //取得选中行
                var selected = $('#'+idName).combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#'+idName).combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) {
                        $('#'+idName).combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } else {
                    var rows = $('#'+idName).combogrid('grid').datagrid('getRows');
                    $('#'+idName).combogrid('grid').datagrid('selectRow', rows.length - 1);
                }
             },
             down: function () {
              //取得选中行
                var selected = $('#'+idName).combogrid('grid').datagrid('getSelected');
                if (selected) {
                    //取得选中行的rowIndex
                    var index = $('#'+idName).combogrid('grid').datagrid('getRowIndex', selected);
                    //向下移动到当页最后一行为止
                    if (index < $('#'+idName).combogrid('grid').datagrid('getData').rows.length - 1) {
                        $('#'+idName).combogrid('grid').datagrid('selectRow', index + 1);
                    }
                } else {
                    $('#'+idName).combogrid('grid').datagrid('selectRow', 0);
                }
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },            
			enter: function () { 
			    //文本框的内容为选中行的的字段内容
                var selected = $('#'+idName).combogrid('grid').datagrid('getSelected');  
			    if (selected) { 
			      $('#'+idName).combogrid("options").value=selected.HIDDEN;
			    }
                //选中后让下拉表格消失
                $('#'+idName).combogrid('hidePanel');
				$("#DiagnosNotes").focus();
            },

			query:function(q){
				if (this.AutoSearchTimeOut) {
					window.clearTimeout(this.AutoSearchTimeOut)
					this.AutoSearchTimeOut=window.setTimeout(function(){
						LoadSyndromeData(q,idName)
					},400)
				}else{
					this.AutoSearchTimeOut=window.setTimeout(function(){
						LoadSyndromeData(q,idName)
					},400)
				}

				$('#'+idName).combogrid("setValue",q);
				//LoadDiagnosData(q);
				
            }
		},
		onClickRow: function (){
			var selected = $('#'+idName).combogrid('grid').datagrid('getSelected');  
			if (selected) { 
			  $('#'+idName).combogrid("options").value=selected.HIDDEN;
			  //SelMRCICDRowid=selected.HIDDEN
			  $("#DiagnosNotes").focus();
			}
		},onChange:function(newValue, oldValue){
	       if (newValue=="") {
		       $('#'+idName).combogrid("setValue","");
		       $('#'+idName).combogrid("options").value="";
		   }
	    }
	});
}

function LoadSyndromeData(q,idName)
{
	var desc=q;
	if (desc=="") return;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCMRDiagnos';
	queryParams.QueryName ='LookUpWithAlias';   
	queryParams.Arg1 =desc;
	queryParams.Arg2 ="";
	queryParams.Arg3 ="";
	queryParams.Arg4 ="";
	queryParams.Arg5 ="2";
	queryParams.ArgCnt =5;
	var opts =  $('#'+idName).combogrid("grid").datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	opts.queryParams = queryParams;
	 $('#'+idName).combogrid("grid").datagrid("load");
	
}

function ReSetFocusForSyn(idname){
	var CurrentPagNum=$(".pagination-num").val()
	window.setTimeout(function (){
		var CurrentOrdName=$('#'+idname).combogrid('getValue');
		if(CurrentOrdName!=""){
			var CheckValue=/^\d+$/;
			if (CheckValue.test(CurrentOrdName)){
				$('#'+idname).combogrid("setValue","");
				$('#'+idname).combo("setText", "")
			}
		}
		setTimeout(function() {
			$('#'+idname).next('span').find('input').focus();
			window.returnValue=false;
		},50)
	},100)
}
function GetSyndromeListInfo(){
	var SyndromeCICDStr="";
	var SyndromeCDescStr="";
	var DiagnosCat=$('input:radio[name="DiagnosCat"]:checked').val();
	if ((UserICDSyndrome!="1")||(DiagnosCat=="0")){return String.fromCharCode(1);}
	$("input[id^='SyndromeSearch']").each(function(i){
		var ICDRowID=$(this).combogrid("options").value;
		var ICDDesc=$(this).next('span').find('input').val();
		if ((ICDRowID=="")&&(ICDDesc!="")){
			ICDDesc=ICDDesc+"#3";
		}else{
			ICDDesc="";
		}
		if ((ICDRowID!="")||(ICDDesc!="")){
			if ((SyndromeCICDStr=="")&&(SyndromeCDescStr=="")){
				SyndromeCICDStr=ICDRowID;
				SyndromeCDescStr=ICDDesc;
			}else{
				SyndromeCICDStr=SyndromeCICDStr+"^"+ICDRowID;
				SyndromeCDescStr=SyndromeCDescStr+"^"+ICDDesc;
			}
		}
		
	});
	return SyndromeCICDStr+String.fromCharCode(1)+SyndromeCDescStr;
}

function RemoveSyndromeList()
{
	var DiagnosCat=$('input:radio[name="DiagnosCat"]:checked').val();
	$("tr[id^='UserICDSyndromeTR']").each(function(i){
		if (i!=0){
			$(this).remove();
		}
	})

}

function DoAfterInserMR(MRDiagnosRowidStr,MRCICDRowid){
	var MRDiagnosRowidStrArr=MRDiagnosRowidStr.split("^")
	var MRDiagnosRowid=MRDiagnosRowidStrArr[0];
	if (MRDiagnosRowid != '') {
		SelMRCICDRowid=""
		LoadDiagnosListDataGrid();
		LoadDiagnosHistoryDataGrid();
		//置患者达到状态
		UpdateArriveStatus();
		//更新发病日期
		var OnsetDate=$("#IDate").datebox("getValue"); 
		for (var i=0;i<MRDiagnosRowidStrArr.length;i++) {
			var ret=cspRunServerMethod(UpdateOnsetDateMethod,MRDiagnosRowidStrArr[i],OnsetDate)
		}
		//页面数据初始化
		ReSetWindowData();
		selMRDiagType="";
		$('#MRDiagType').combobox('reload'); 
		$("#SelDiagRowId").val("")
		ClearSyndrome();
	}
	CheckDiseaseNew(MRDiagnosRowid,EpisodeID,PatientID);
	//临床路径准入提示校验,提示是否入径
	ShowCPW(MRCICDRowid,MRDiagnosRowid); 
	if (MRCICDRowid!="") {
		var ClinicPathWayRowId = cspRunServerMethod(FindClinicPathWayByICDMethod,MRCICDRowid);
		if (ClinicPathWayRowId!="") {
			var posn="height="+(screen.availHeight-400)+",width="+(screen.availWidth-200)+",top=200,left=100,toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
			var path="websys.default.csp?WEBSYS.TCOMPONENT=UDHCOEOrder.CPW.Edit&CPWRowId="+ClinicPathWayRowId+"&EpisodeID="+EpisodeID;
			websys_createWindow(path,false,posn);
		}
	}
	SaveMRDiagnosToEMR();
}

function ShowLMPWindow(){
	$('#WeekNum').val("");
	$('#LMPDateWindow').window({
	    title: "末次月经时间",
	    width: 500,
	    height: 400,
	    zIndex: 9999,
	    inline: false,
	    minimizable: false,
	    maximizable: false,
	    collapsible: false,
	    closable: false
			
	});
	InitLMPWindow();
	return;
}

function LMPWindowDestroy(){
	/*
	$('#LMPDate').datebox("destroy");
	$('#LMPSlider').slider("destroy");
	$('#LMPDate').datebox("destroy");
	*/
	$('#LMPBSave').unbind("click");
	$('#LMPBCancel').unbind("click");
	$('#LMPResult').html("");
	$('#WeekNum').val(1);
}
function ComputeLMP(Seldate){
	var LMPDate = new Date(Seldate.getFullYear(),Seldate.getMonth(),Seldate.getDate(),0,0);
    var CurrDate = new Date();
    var CurrDate = new Date(CurrDate.getFullYear(),CurrDate.getMonth(),CurrDate.getDate(),0,0);
    var Days = (CurrDate-LMPDate)/(24*60*60*1000);
	var WeekNum=parseInt(Days/7);
	var LeftDays=Days%7;
	if (WeekNum==0){
		//WeekNum=1;LeftDays=0;
	}
	var LMPYear=Seldate.getFullYear();
	var LMPMonth=Seldate.getMonth()+1;
	var LMPDay=Seldate.getDate();
	//预产期的月份就是那个月的月份如果是大于3就减去3，月份小于3就加9就是出生的月份，日期：加7天就是出生的日期
	if (LMPMonth>3){
		LMPMonth=LMPMonth-3;
		LMPYear=LMPYear+1
	}else{
		LMPMonth=LMPMonth+9;
	}
	LMPDay=LMPDay+7;
	var DueDate=new Date(LMPYear,LMPMonth-1,LMPDay,0,0);
	if (DateDefaultFormat==4) DueDate=DueDate.getDate()+"/"+(DueDate.getMonth()+1)+"/"+DueDate.getFullYear();
	else  DueDate=DueDate.getFullYear()+"-"+(DueDate.getMonth()+1)+"-"+DueDate.getDate();
	if (WeekNum==0) var Info="孕"+LeftDays+"天,预产期:"+DueDate
	else var Info="孕"+WeekNum+"周"+LeftDays+"天,预产期:"+DueDate;
	$('#WeekNum').val(WeekNum);
	$('#LMPSlider').slider("setValue",WeekNum);
	$('#LMPResult').html(Info);
}
function InitLMPWindow(){
	$('#LMPDate').datebox({    
		onSelect:function(Seldate){
			ComputeLMP(Seldate);
			
		},
		onChange:function(newValue, oldValue){
			if (DateDefaultFormat==3){
				var myrtn=DHCWeb_IsDate(newValue,"-")
			}
			if (DateDefaultFormat==4){
				var myrtn=DHCWeb_IsDate(newValue,"/")
			}
			if (myrtn){
				var date=myparser(newValue);
				ComputeLMP(date);
			}
			
		}
	});
	$('#LMPSlider').slider({
		value:1,
		/*onSlideEnd:function(Value){
			var WeekNum=$('#WeekNum').val();
			//alert(WeekNum+","+newValue)
			if (WeekNum!=Value){
				var Info="孕"+Value+"周";
				$('#LMPResult').html(Info);
				$('#WeekNum').val(Value);
			}
		},*/
		onChange:function(newValue, oldValue){
			if (WeekNum!=newValue){
				var Info="孕"+newValue+"周";
				$('#LMPResult').html(Info);
				$('#WeekNum').val(newValue);
			}
		}
	});
	///class="easyui-datebox" data-options="formatter:myformatter,parser:myparser"
	$('#LMPDate').datebox({
		formatter:myformatter,
		parser:myparser
		
	});
	$('#LMPBSave').click(function(){
		var MRCICDRowid=cspRunServerMethod(GetWeekDiagnoseMethod,$('#WeekNum').val());
		if (MRCICDRowid==""){
			alert("尚未维护该周对应的诊断，请联系系统管理员");
			return false;
		}
		var rtn=InsertMRDiagnos(MRCICDRowid);
		if (rtn){
			LMPWindowDestroy();
			$('#LMPDateWindow').window('close', true);
		}
		
	});
	$('#LMPBCancel').click(function(){
		LMPWindowDestroy();
		$('#LMPDateWindow').window('close', true);
	});
}
function ClearSyndrome(){
	var DiagnosCat=$('input:radio[name="DiagnosCat"]:checked').val();
	if ((UserICDSyndrome!="1")||(DiagnosCat=="0")) return ;
	$("input[id^='SyndromeSearch']").each(function(i){
		$(this).combogrid("options").value="";
	});
}
//FromHisDB
function ShowFormWindow(MRCICDRowid,DiagnosValue,Type){
	if (typeof Type =="undefined"){
		Type="";
	}
	var title="诊断属性列表";
	if ((DiagnosValue!="")&&(Type=="")){
		title=title+"修改";
	}
	$('#FormWindow').removeAttr("style");
	$('#FormWindow').window({
	    title: title,
	    width: 920,
	    height: 600,
	    zIndex: 9999,
	    inline: false,
	    minimizable: false,
	    maximizable: false,
	    collapsible: false,
	    closable: false
			
	});
	InitFormWindow(MRCICDRowid,DiagnosValue,Type);
	return;
}
function ChangeDiagDescWinClose(){
	$('#Form_DiagDisplayNameList').combobox('setValue','');
	$('#Form_DiagDisplayNameList').combobox('setText','');
	$('#ChangeDiagDescWindow').window('close', true);
}
function ChangeDiagDescWinSure(){
	var desc=$('#Form_DiagDisplayNameList').combobox('getText');
	desc=desc.replace(/[\\\@\#\$\%\^\&\*\(\)\{\}\:\"\<\>\?\[\]]/g,"");
	if (desc!=""){
		var oldDiagName=$("#Form_DiagDesc").val(); //"肺癌(肺及支气管恶性肿瘤)(分期_TNM标准,分型_病理,分型_大体)(T.T0)(T.T0)(T.T0)" //
		var NameArr=oldDiagName.split("(");
		NameArr[0]=desc;
		$("#Form_DiagDesc").val(NameArr.join("("));
	}
	ChangeDiagDescWinClose();
}
function ChangeDiagDisplayDescClick(){
	//$("#Form_DiagDisplayNameList")
	//debugger;
	//$('#Form_DiagDisplayNameList').combobox('getData');
	$('#ChangeDiagDescWindow').removeAttr("style");
	$('#ChangeDiagDescWindow').window({
	    title: "切换诊断展示名",
	    width: 300,
	    height: 200,
	    zIndex: 9999,
	    inline: false,
	    minimizable: false,
	    maximizable: false,
	    collapsible: false,
	    closable: false
			
	});
	return;
}
function SetDiagnosStatus(DiagStatDr)
{
	if (DiagStatDr==DiaD){
		var Status="QZ"
	}else if (DiagStatDr==DiaW){
		var Status="DZ"
	}else{
		var Status="YZ"
	}
	$("input[name='DiagStatus'][value="+Status+"]").attr("checked",true);
}
function GetDiagnosStatus(){
	var checkedVal=$('input:radio[name="DiagStatus"]:checked').val();
	if ((checkedVal!="")&&(checkedVal!=undefined)){
		if(checkedVal=="QZ"){
		  DiagnosStatus=DiaD
		}else if(checkedVal=="DZ"){
			  DiagnosStatus=DiaW
		}else{
			  DiagnosStatus=DiaH
		}
	}
	return DiagnosStatus;
}
function InitFormWindow(MRCICDRowid,DiagnosValue,Type){
	//$("#SelDiagRowId").val(MRCICDRowid);
	var TreeCheckedIdStr="",ComboCheckedIdStr="",RadioCheckedIdStr="",CheckBoxCheckedIdStr="",DiagPNotes=""
	var NeedLoadDiagPInfoFlag=0;
	if (Type==""){
		if (MRCICDRowid!=""){
			$("#SelDiagRowId").val("");
			LoadDiagProChangeListDataGrid("");
			//SetDocSelInfo();
		}else{
			if (Type=="") $("#SelDiagRowId").val(DiagnosValue);
			NeedLoadDiagPInfoFlag=1;
		}
	}else{
		NeedLoadDiagPInfoFlag=1;
	}
	var DiagStatDr=DiagnosStatus;
	var DiagNotes=$("#DiagnosNotes").val();
	DiagNotes=DiagNotes.replace(/[\\\@\#\$\%\^\&\*\(\)\{\}\:\"\<\>\?\[\]]/g,"");
	var MainDiaType="N";
	if ($("#MainDiaType").is(":checked")) {MainDiaType="Y";}else{MainDiaType="N";}
	var DiagnosTypeId=$("#MRDiagType").combobox("getValue");
	var BPSystolic=$("#BPSystolic").val().replace(/(^\s*)|(\s*$)/g,'');	
	var BPDiastolic=$("#BPDiastolic").val().replace(/(^\s*)|(\s*$)/g,'');
	var LinkICDRowid="";
	if (NeedLoadDiagPInfoFlag==1){
		//根据诊断表ID，获取诊断属性相关信息
		var ret=tkMakeServerCall("web.DHCMRDiagnos","GetDiagPropertyByRowId",DiagnosValue);
		if (ret!=""){
			MRCICDRowid=ret.split("^")[0];
			TreeCheckedIdStr=ret.split("^")[1];
	        ComboCheckedIdStr=ret.split("^")[2];
	        RadioCheckedIdStr=ret.split("^")[3];
	        CheckBoxCheckedIdStr=ret.split("^")[4];
	        DiagPNotes=ret.split("^")[5];
	        var DiagnosDisPlayName=ret.split("^")[6];
	        var DiagStatDr=ret.split("^")[7];
	        
	        MainDiaType=ret.split("^")[8];
	        DiagNotes=ret.split("^")[9];
	        DiagnosTypeId=ret.split("^")[10];
	        LinkICDRowid=ret.split("^")[11];
	        if (DiagnosDisPlayName!="") findCondition=DiagnosDisPlayName;
		}else{
			return false;
		}
	}
	SetDiagnosStatus(DiagStatDr);
	$("#Form_DiagNotes").val(DiagNotes);
	InitMRDiagType("Form_DiagType");
	if (MainDiaType=="Y"){
		$("#Form_MainDiaType").attr('checked',true);
	}
	if (DiagnosTypeId!=""){
		$("#Form_DiagType").combobox('setValue', DiagnosTypeId);
	}
	if (NeedStolicMast==1){
		$("#Form_BPSystolic").val(BPSystolic);	
		$("#Form_BPDiastolic").val(BPDiastolic);
	}
	
	var DisplayNameFlag="",DisplayDiagList="";
	var $ff=$("#DiagForm"); //table
	var $templ=$("#formTemplate"); //tr
	var RetStr = cspRunServerMethod(GetDiagTempData, MRCICDRowid);
	if (RetStr!=""){
		var RetStrArr=RetStr.split("^");
		var DKBBCRowId=RetStrArr[0]; //属性模板Id
		var emptyInfo=RetStrArr[1];
		//14561^2075(1786,1787,1788,15243,15244)
		//^1786分型TT1787并发症LC1788诊疗_症状体征LC           15243引用术语--下拉树ST15244引用术语--下拉框SC
		if (emptyInfo=="") {
			return ;
		}
		$("#SelTKBRowId").val(MRCICDRowid);
		var modeJsonInfo=$.parseJSON(RetStrArr[2]);
		//展示缺省属性 start
		/*var emptyPropertyStr=emptyInfo.split("(")[1].split(")")[0];
		var tool=$templ.clone();
		tool.removeAttr("style");
		tool.removeAttr("id");
		tool.addClass("dynamic_tr");
		tool.attr("id",DKBBCRowId+"_"+emptyInfo.split("(")[0]);
		$ff.append(tool);
		$("label",tool).removeAttr("style");
		$("label",tool).html("缺省属性");
		var TA_tool="";
		for (var i=0;i<emptyPropertyStr.split(",").length;i++){
			var id=emptyPropertyStr.split(",")[i];
			//id=DKBBCRowId+"_"+id;
			var desc=modeJsonInfo[i].catDesc;
			var OneTA_tool="<input type='checkbox' class='emptyPropertyCheckbox' style='vertical-align:middle;padding:0px;' name='"+id+"_Empty_CG'"+"id='"+id+"_Empty_CG'>"+"<span id='"+id+"_Empty_CGSpan'>"+desc+"</span>"
			if (TA_tool=="") TA_tool="<td style='width:80%;'>"+OneTA_tool;
            else TA_tool=TA_tool+OneTA_tool;
		}
		if (TA_tool!=""){
			TA_tool=TA_tool+"</td>";
			tool.append(TA_tool);
			 $(document.body).bind("keydown",BodykeydownHandler)
			 $(".emptyPropertyCheckbox").bind("click",PropertyCheckboxChange);
			
		}*/
		//展示缺省属性 end		
		
			 $(modeJsonInfo).each(function(index,item){
				var childId=modeJsonInfo[index].catRowId;
				var childDesc=modeJsonInfo[index].catDesc;
				var childType=modeJsonInfo[index].catType; //L列表 T树形 TX文本 S引用术语类型
				var showType=modeJsonInfo[index].showType; 
				var catFlag=modeJsonInfo[index].catFlag; //Y 表示诊断展示名
				if (childType=="L"){
					var ListRetStr = cspRunServerMethod(GetDiagListProperty, "",childId,"0","1000");
					ListRetStr=eval("("+ListRetStr+")");
					var C_valueField='TKBTDRowId';  
					var C_textField='TKBTDDesc';
				}
				if (childType=="T"){
					var TreeRetStr = cspRunServerMethod(GetChildTreeJson, "TreeRoot",childId,"");
					TreeRetStr=$.parseJSON(TreeRetStr);
				}
				if (childType=="TX"){
					var TXRetStr = cspRunServerMethod(GetDiagTXProperty,childId);
				}
				if (childType=="S"){
					if ((showType=="C")||(showType=="CB")||(showType=="CG")) { //引用术语 展示为下拉框
						var ListRetStr =cspRunServerMethod(GetDocSourseList,childId,"L","");
						ListRetStr=eval("("+ListRetStr+")");
						var C_valueField='TKBTRBRowId';  
						var C_textField='TKBTRBDesc';
					}else if (showType=="T"){
						var TreeRetStr=cspRunServerMethod(GetSourseTreeJson,"",childId,"");
						TreeRetStr=$.parseJSON(TreeRetStr);
					}else{
						var SRetStr = cspRunServerMethod(GetSoursePropertyInfo,childId);
					}
				}
				if (childType=="C"){
					var ListRetStr=cspRunServerMethod(GetDocCatList,childId,"");
					ListRetStr=eval("("+ListRetStr+")")
					if (showType=="C") {
						var C_valueField='TKBTERowId';  
						var C_textField='TKBTEDesc';
					}
				}
				if (catFlag=="Y"){
					//诊断展示名显示在诊断名称一行
					/*$("#Form_DiagDesc").combobox({
						editable: true,
						multiple:false,
						width:'430',
					  	valueField:C_valueField,   
					  	textField:C_textField,
					  	data:ListRetStr.data,
					  	onLoadSuccess:function(){
						  	var MatchingFlag=0;
						  	if(findCondition!=""){
							  	var ListData=$(this).combobox('getData');
							  	for (var m=0;m<ListData.length;m++){
								  	if ((ListData[m].TKBTDDesc==findCondition)||(ListData[m].TKBTDDesc.indexOf(findCondition)>=0)){
										 $(this).combobox('setValue', ListData[m].TKBTDRowId);
										 MatchingFlag=1;
										 break;
									}
								}
							}
							if (MatchingFlag==0){
								$(this).combobox('setValue', ListData[0].TKBTDRowId);
							}
						}
					});
					$("#"+childId+"_Empty_CG").remove();
					$("#"+childId+"_Empty_CGSpan").remove();
					var $dynamic_tr=$(".dynamic_tr"); 
					var trids=$dynamic_tr[0].id;
					var tds=$("#"+trids+"").children();
					if (tds[1].innerHTML==""){
						$("#"+trids+"").css("display","none")
					}*/
					DisplayNameFlag="Y";
					DisplayDiagList=ListRetStr.data;
				}else{
					var tool=$templ.clone();
					tool.removeAttr("style");
					tool.removeAttr("id");
					tool.attr("id",DKBBCRowId+"_"+childId+"_"+showType);
					tool.addClass("dynamic_tr");
					tool.addClass("tr_dispaly");
					$ff.append(tool);
					$("label",tool).removeAttr("style");
					/*
					  ['C','下拉框'],
				      ['T','下拉树'],
				      ['TX','文本框'],
				      ['TA','多行文本框'],
				      ['CB','单选框'],
				      ['CG','复选框']
					*/
					$("label",tool).html(childDesc);
					var FindSelectFlag=0;
					if (showType=="TX"){
						if (childType=="S"){
							var TXText=SRetStr.split("[A]")[2];
							var TXId=SRetStr.split("[A]")[1];
						}else{
						    var TXText=TXRetStr.split("[A]")[1];
						    var TXId=TXRetStr.split("[A]")[0];
						}
						var TX_tool="<td><label id='"+childId+"_"+TXId+"_TX"+"'>"+TXText+"</label></td>"  
						tool.append(TX_tool);
					}
					if (showType=="TA"){
						if (childType=="S"){
							var TAText=SRetStr.split("[A]")[2];
							var TAId=SRetStr.split("[A]")[1];
						}
						if (childType=="TX") {
							var TARetStr = TXRetStr;
							var TAId=TARetStr.split("[A]")[0];
							var TAText=TARetStr.split("[A]")[1];
						}
						var TA_tool="<td><textarea disabled='disabled' style='width:98%;background:transparent;border:0px;' id='"+childId+"_"+TAId+"_TA"+"'>"+TAText+"</textarea></td>"  
						tool.append(TA_tool);
					}
					if (showType=="CB"){
						var CBRetStr = ListRetStr;
						var TA_tool="";
						for (var k=0;k<CBRetStr.data.length;k++){
							if (childType=="S"){
								var CBId=CBRetStr.data[k].TKBTRBRowId;
	                        	var CBDesc=CBRetStr.data[k].TKBTRBDesc;
							}else if(childType=="C"){
								var CBId=CBRetStr.data[k].TKBTERowId;
	                        	var CBDesc=CBRetStr.data[k].TKBTEDesc;
							}else{
								var CBId=CBRetStr.data[k].TKBTDRowId;
	                        	var CBDesc=CBRetStr.data[k].TKBTDDesc;
							}
	                        if (("$"+RadioCheckedIdStr+"$").indexOf("$"+CBId+"$")>=0){
		                        var OneTA_tool="<input type='radio' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CB'"+"id='"+childId+"_"+CBId+"_CB' checked>"+"<span>"+CBDesc+"</span>"
		                    	FindSelectFlag=1;
		                    }else{
			                    var OneTA_tool="<input type='radio' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CB'"+"id='"+childId+"_"+CBId+"_CB'>"+"<span>"+CBDesc+"</span>"
			                }
	                        if (TA_tool=="") TA_tool="<td>"+OneTA_tool;
	                        else TA_tool=TA_tool+OneTA_tool;
						}
						if (TA_tool!=""){
							TA_tool=TA_tool+"</td>";
							tool.append(TA_tool);
						}
					}
					if (showType=="CG"){
						var CGRetStr = ListRetStr 				
						var TA_tool="";
						for (var k=0;k<CGRetStr.data.length;k++){
							if (childType=="S"){
								var CGId=CGRetStr.data[k].TKBTRBRowId;
	                        	var CGDesc=CGRetStr.data[k].TKBTRBDesc;
							}else if(childType=="C"){
								var CGId=CGRetStr.data[k].TKBTERowId;
	                        	var CGDesc=CGRetStr.data[k].TKBTEDesc;
							}else{
								var CGId=CGRetStr.data[k].TKBTDRowId;
	                        	var CGDesc=CGRetStr.data[k].TKBTDDesc;
							}
	                        if (("$"+CheckBoxCheckedIdStr+"$").indexOf("$"+CGId+"$")>=0){
		                        FindSelectFlag=1;
		                        var OneTA_tool="<input type='checkbox' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CG'"+"id='"+childId+"_"+CGId+"_CG' checked>"+"<span>"+CGDesc+"</span>"
		                    }else{
			                    var OneTA_tool="<input type='checkbox' style='vertical-align:middle;padding:0px;' name='"+childId+"_"+index+"_CG'"+"id='"+childId+"_"+CGId+"_CG'>"+"<span>"+CGDesc+"</span>"
			                }
	                        if (TA_tool=="") TA_tool="<td>"+OneTA_tool;
	                        else TA_tool=TA_tool+OneTA_tool;
						}
						if (TA_tool!=""){
							TA_tool=TA_tool+"</td>";
							tool.append(TA_tool);
						}
					}
					if (showType=="C"){
						var FindSelectFlag=0;
						var Data=ListRetStr.data;
						var Combo_tool="<td style=''><input id='"+childId+"_C"+"' class='easyui-combobox' /></td>"
						tool.append(Combo_tool);
						$("#"+childId+"_C").combobox({
							editable: true,
							multiple:false,
							width:'370',
							//selectOnNavigation:true,
						  	valueField:C_valueField,   
						  	textField:C_textField,
						  	data:Data,
						  	onLoadSuccess:function(){
							  	if(ComboCheckedIdStr!=""){
								  	var ListData=$(this).combobox('getData');
								  	for (var m=0;m<ListData.length;m++){
									  	if (childType=="S"){
										  	if (("$"+ComboCheckedIdStr+"$").indexOf("$"+ListData[m].TKBTRBRowId+"$")>=0){
											  	$(this).combobox('setValue', ListData[m].TKBTRBRowId);
											  	FindSelectFlag=1;
											}
										}
										if (childType=="C"){
											if (("$"+ComboCheckedIdStr+"$").indexOf("$"+ListData[m].TKBTERowId+"$")>=0){
											  	$(this).combobox('setValue', ListData[m].TKBTERowId);
											  	FindSelectFlag=1;
											}
										}else{
											if (("$"+ComboCheckedIdStr+"$").indexOf("$"+ListData[m].TKBTDRowId+"$")>=0){
											  	$(this).combobox('setValue', ListData[m].TKBTDRowId);
											  	FindSelectFlag=1;
											}
										}
									  	
									}
								}
							},
							onSelect:function(record){
								InitDiagPLinkICDCombo();
							}
						});
					}
					if (showType=="T"){
						var tmpTreeCheckedIdStr=TreeCheckedIdStr;
						var FindSelectFlag=0;
						var Tree_tool="<td><ul class='easyui-tree' id='"+childId+"_T"+"'></ul></td>"
						tool.append(Tree_tool);
						var tree=$("#"+childId+"_T"+"").tree({
							checkbox:true,
							//onlyLeafCheck:true,
							lines:true,
							multiple:true,
							cascadeCheck:false,
							data:TreeRetStr,
							onCheck:function(node, checked){
								//要求：树形节点，如果选择子节点，那么父节点自动选中，如果选择父节点，子节点不做处理
								//      允许树形节点多个选中，涉及临床专业知识的，如TNP每个必须选中一个的不做处理
								if (checked){
								   var  node1=$(this).tree("getParent",node.target);          //得到父节点
								   if (node1){
									   if ((tmpTreeCheckedIdStr=="")||((("$"+tmpTreeCheckedIdStr+"$").indexOf("$"+node1.id+"$")!=-1)&&(TreeCheckedIdStr!=""))){
										 $(this).tree('check', node1.target);   //选中父节点
									   }
								   }
								   if (!$(this).tree("isLeaf",node.target)) $(this).tree("expand",node.target);
								}else{
									//获取选中的节点
									var CheckedId=""; 
									var treeCheckedIds=$(this).tree('getChecked');
									for (var k=0;k<treeCheckedIds.length;k++){
										var OneTreeCheckedId=treeCheckedIds[k].id;
										if (CheckedId=="") CheckedId=OneTreeCheckedId;
										else  CheckedId=CheckedId+"$"+OneTreeCheckedId;
									}
									//得到父节点
									var FindChildCheckedFlag=0;
									var  node1=$(this).tree("getParent",node.target);
									if ((node1)&&(node1.children)){
										for (var i=0;i<node1.children.length;i++){
											if (("$"+CheckedId+"$").indexOf("$"+node1.children[i].id+"$")!=-1) {
												FindChildCheckedFlag=1;
											}
										}
									}
									if (FindChildCheckedFlag==0){
										if (node1) $(this).tree('uncheck', node1.target);
										//if (!$(this).tree("isLeaf",node1.target)) $(this).tree("collapse",node1.target);
									}
									
								}
								InitDiagPLinkICDCombo();
								//var nodes = $('#tt').tree('getChecked','indeterminate');  
								/*var nodes =$("#"+childId+"_T"+"").tree('getChecked');
								if(nodes.length>1){ 
									for (var i=0;i<nodes.length;i++){
										var ids=nodes[i].id;
										if (ids==node.id) continue 
										var node1 = $("#"+childId+"_T"+"").tree('find',ids); 
										$("#"+childId+"_T"+"").tree('uncheck',node1.target);
									}
							    }*/
							},onLoadSuccess:function(node, data){
								var Roots=$(this).tree('getRoots');
								for (var j=0;j<Roots.length;j++){
									if (!$(this).tree("isLeaf",Roots[j].target)) $(this).tree("collapseAll",Roots[j].target);
								}
								if (TreeCheckedIdStr!=""){
									for (var m=0;m<TreeCheckedIdStr.split("$").length;m++){
										var tmpnode = $(this).tree('find', TreeCheckedIdStr.split("$")[m]);
										if (tmpnode){
											$(this).tree('check', tmpnode.target);
											$(this).tree("expand",tmpnode.target);
											FindSelectFlag=1;
											
										}
									}
								}
								for (var j=0;j<Roots.length;j++){
										if (!$(this).tree("isLeaf",Roots[j].target)) $(this).tree("expand",Roots[j].target);
								}
								tmpTreeCheckedIdStr="";
							}
						})
						
					}
					if (FindSelectFlag==1){
						$("#"+DKBBCRowId+"_"+childId+"_"+showType+"").removeClass("tr_dispaly");
						$("#"+childId+"_Empty_CG").attr('checked',true);
					}
				}
			 })
	    if (findCondition==""){
			findCondition=$('#DiagnosSearch').combo("getText");
		}
		$("#Form_DiagDesc").val(findCondition);
		if (DisplayNameFlag=="Y"){ //存在诊断展示名属性
			//NeedLoadDiagPInfoFlag
			/*var listdata=cspRunServerMethod(GetDiagDisPlayNameJson,MRCICDRowid,findCondition);
			listdata=eval("("+listdata+")");
			$("#Form_DiagDesc").combobox({
				editable: true,
				multiple:false,
				width:'430',
			  	valueField:'id',   
			  	textField:'text',
			  	data:listdata,
			  	onLoadSuccess:function(){
				  	$(this).combobox('setValue', findCondition);
				  	var MatchingFlag=0;
				  	if(findCondition!=""){
					  	var ListData=$(this).combobox('getData');
					  	for (var m=0;m<ListData.length;m++){
						  	if ((ListData[m].text==findCondition)||(ListData[m].text.indexOf(findCondition)>=0)){
								 $(this).combobox('setValue', ListData[m].id);
								 MatchingFlag=1;
								 break;
							}
						}
					}
					if (MatchingFlag==0){
						$(this).combobox('setValue', ListData[0].id);
					}
				}
			});*/
		}else{
			var listdata=cspRunServerMethod(GetDiagDisPlayNameJson,MRCICDRowid,findCondition);
			DisplayDiagList=eval("("+listdata+")");
		}
		if (DisplayDiagList.length>1){
			$("#Form_DiagDisplayNameList").combobox({
				editable: true,
				multiple:false,
				width:'280',
			  	valueField:'TKBTDRowId',   
			  	textField:'TKBTDDesc',
			  	data:DisplayDiagList,
			  	onLoadSuccess:function(){
				  	if (NeedLoadDiagPInfoFlag!="1"){
					  	//$(this).combobox('setValue', findCondition);
					  	var MatchingFlag=0;
					  	if(findCondition!=""){
						  	var ListData=$(this).combobox('getData');
						  	for (var m=0;m<ListData.length;m++){
							  	if ((ListData[m].TKBTDDesc==findCondition)||(ListData[m].TKBTDDesc.indexOf(findCondition)>=0)){
									 //$(this).combobox('setValue', ListData[m].id);
									 $("#Form_DiagDesc").val(ListData[m].TKBTDDesc)
									 MatchingFlag=1;
									 break;
								}
							}
						}
						if (MatchingFlag==0){
							//$(this).combobox('setValue', ListData[0].id);
							$("#Form_DiagDesc").val(ListData[0].TKBTDDesc)
						}
					}
				}
			})
			
		}else{
			if (NeedLoadDiagPInfoFlag!="1"){
				$("#Form_DiagDesc").val(DisplayDiagList[0].TKBTDDesc);
			}else{
			}
			$("#ChangeDiagDisplayDesc").hide();
		}
		$('#FormLookUserDKB').unbind("click"); //移除click
		$("#FormLookUserDKB").click(function(){
			var repUrl="dhc.bdp.ext.default.csp?extfilename=App/MKB/TKB_ListTremRead&base="+TKBTremBaseId+"&RelationId="+MRCICDRowid;
	        window.open(repUrl,"_blank","height=600,width=1100,left=50,top=50,status=yes,toolbar=no,menubar=no,resizable=yes")
		});
		//诊断属性备注,此备注可被修改且有修改日志记录
		var DiagPNotes_tool="<tr class='dynamic_tr'><td class='td_label'><label>属性备注</label></td><td><input type='text' style='width:99.8%;' id='DiagPNotes'></td></tr>" 
		$ff.append(DiagPNotes_tool); 
		//关联icd诊断
		//var Combo_tool="<td style='width:80%;'><input id='"+childId+"_C"+"' class='easyui-combobox' /></td>"
		var DiagPLinkICD_tool="<tr class='dynamic_tr'><td class='td_label'><label>关联ICD</label></td><td><input class='easyui-combobox' style='' id='DiagPLinkICD'></td></tr>" 
		$ff.append(DiagPLinkICD_tool); 
		InitDiagPLinkICDCombo();
		$("#DiagPNotes").val(DiagPNotes);
		//$("#formbtn").removeAttr("style");
		$ff.append($("#frombtn"));
		$('input:checkbox').click(function (e) { 
		   if (e.target.id.indexOf("_CG")>=0){
			   InitDiagPLinkICDCombo();
		   }
		})
		$('input:radio').click(function (e) { 
		   if (e.target.id.indexOf("_CB")>=0){
			   InitDiagPLinkICDCombo();
		   }
		})
		if ((NeedLoadDiagPInfoFlag==1)&&(LinkICDRowid!="")){
			$("#DiagPLinkICD").combobox('setValue',LinkICDRowid);
		}
		
	}
}
function InitDiagPLinkICDCombo(){
	var info=$("#SelTKBRowId").val();
	if (info=="") return false;
	var SelectedPropertyStr=GetSelectedPropertyStr();
	if (SelectedPropertyStr!="") info=info+"-"+SelectedPropertyStr;
	var ListRetStr=cspRunServerMethod(GetDiagPLinkICDJson,info);
	ListRetStr=eval("("+ListRetStr+")")
	$("#DiagPLinkICD").combobox({
		editable: true,
		multiple:false,
		width:'370',
	  	valueField:"id",   
	  	textField:"text",
	  	data:ListRetStr,
	  	onLoadSuccess:function(){
		}
	});
}
function GetSelectedPropertyStr(){
	var SelectedPropertyStr="";
	var SelectedPropertyDesc="";
	var $dynamic_tr=$(".dynamic_tr"); 
	for (var i=0;i<($dynamic_tr.length-2);i++){
		var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType
		var id=trids.split("_")[0]; //诊断模板属性id
		var showtype=trids.split("_")[2];
		var tds=$("#"+trids+"").children();
		var oneSelectedPropertyStr="";
		var oneSelectedPropertyDesc="";
		for (var j=1;j<tds.length;j++){
			var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
			var type=detailId.split("_")[detailId.split("_").length-1];
		    if (type=="T"){
			    var treeCheckedIds=$("#"+detailId+"").tree('getChecked');
			    for (var k=0;k<treeCheckedIds.length;k++){
					var OneTreeCheckedId=treeCheckedIds[k].id;
					var oneTreeCheckedDesc=treeCheckedIds[k].target.innerText
					if (oneSelectedPropertyStr=="") oneSelectedPropertyStr=OneTreeCheckedId;
					else  oneSelectedPropertyStr=oneSelectedPropertyStr+"*"+OneTreeCheckedId;
					if ($("#"+detailId+"").tree('getParent',$("#"+detailId+"").tree('find',OneTreeCheckedId).target)){
						if (oneSelectedPropertyDesc=="") oneSelectedPropertyDesc=oneTreeCheckedDesc;
					    else  oneSelectedPropertyDesc=oneSelectedPropertyDesc+"."+oneTreeCheckedDesc;
					}else{
						if (oneSelectedPropertyDesc=="") oneSelectedPropertyDesc=oneTreeCheckedDesc;
					     else  oneSelectedPropertyDesc=oneSelectedPropertyDesc+","+oneTreeCheckedDesc;
					}
					
				}
			}
			if (type=="C"){
				var ComboSelId=$("#"+detailId+"").combobox('getValue');
				var ComboSelText=$("#"+detailId+"").combobox('getText');
				if (oneSelectedPropertyStr=="") oneSelectedPropertyStr=ComboSelId;
				else  oneSelectedPropertyStr=oneSelectedPropertyStr+"*"+ComboSelId;
				if (ComboSelId!=""){
					if (oneSelectedPropertyDesc=="") oneSelectedPropertyDesc=ComboSelText;
					else  oneSelectedPropertyDesc=oneSelectedPropertyDesc+","+ComboSelText;
				}
			}
			//单选框
			if (type=="CB"){
				var radioName=detailId.split("_")[0]+"_"+(i)+"_CB";
				var obj=$('input[name='+radioName+']:checked');
				var CheckedObj=obj[0];
				//$('input[name='+radioName+']:checked').next().text()
				if(CheckedObj!=undefined){
					var CBSelId=CheckedObj.id.split("_")[1];
					var CBSelDesc=obj.next().text();
					if (oneSelectedPropertyStr=="") oneSelectedPropertyStr=CBSelId;
					else  oneSelectedPropertyStr=oneSelectedPropertyStr+"*"+CBSelId;
					if (oneSelectedPropertyDesc=="") oneSelectedPropertyDesc=CBSelDesc;
					else  oneSelectedPropertyDesc=oneSelectedPropertyDesc+","+CBSelDesc;
				}
			}
			//多选框
			if (type=="CG"){
				var checkboxName=detailId.split("_")[0]+"_"+(i)+"_CG";
				var CheckedObj=$('input[name='+checkboxName+']:checked');
				if (CheckedObj!=undefined){
					for (var m=0;m<CheckedObj.length;m++){
						var CGSelId=CheckedObj[m].id.split("_")[1];
						var CGSelDesc=$("#"+CheckedObj[m].id+"").next().text();
						if (oneSelectedPropertyStr=="") oneSelectedPropertyStr=CGSelId;
					    else  oneSelectedPropertyStr=oneSelectedPropertyStr+"*"+CGSelId;
					    
					    if (oneSelectedPropertyDesc=="") oneSelectedPropertyDesc=CGSelDesc;
					    else  oneSelectedPropertyDesc=oneSelectedPropertyDesc+","+CGSelDesc;
					}
				}
			}
		}
		if (oneSelectedPropertyStr!=""){
			oneSelectedPropertyStr=trids.split("_")[1]+":"+oneSelectedPropertyStr;
			if (SelectedPropertyStr=="") SelectedPropertyStr=oneSelectedPropertyStr;
			else  SelectedPropertyStr=SelectedPropertyStr+","+oneSelectedPropertyStr;
			
			if (SelectedPropertyDesc=="") SelectedPropertyDesc=oneSelectedPropertyDesc;
			else  SelectedPropertyDesc=SelectedPropertyDesc+","+oneSelectedPropertyDesc;
			
		}
		
	}
	var OldDiagDesc=$("#Form_DiagDesc").val().split("(")[0];
	if (SelectedPropertyDesc!=""){
		$("#Form_DiagDesc").val(OldDiagDesc+"("+SelectedPropertyDesc+")");
	}else{
		$("#Form_DiagDesc").val(OldDiagDesc);
	}
	
	return SelectedPropertyStr;
}
function GetDiagFormData(){
	var TreeDataStr="";
	var ComboDataStr="";
	var RadioDataStr="";
	var CheckDataStr="";
	var DKBBCRowId="";
	var $dynamic_tr=$(".dynamic_tr"); 
	for (var i=0;i<($dynamic_tr.length-2);i++){
		var trids=$dynamic_tr[i].id; //DKBBCRowId+"_"+childId+"_"+showType
		var id=trids.split("_")[0]; //诊断模板属性id
		var showtype=trids.split("_")[2];
		DKBBCRowId=id;
		var tds=$("#"+trids+"").children();
		for (var j=1;j<tds.length;j++){
			var detailId=$("#"+trids+" td").children()[1].id; //具体属性id
			var type=detailId.split("_")[detailId.split("_").length-1];
			if (type=="T"){
				//获取显示方式为树类型的选择节点串
				var CheckedId=""; 
				var treeCheckedIds=$("#"+detailId+"").tree('getChecked');
				for (var k=0;k<treeCheckedIds.length;k++){
					var OneTreeCheckedId=treeCheckedIds[k].id;
					if (CheckedId=="") CheckedId=OneTreeCheckedId;
					else  CheckedId=CheckedId+"$"+OneTreeCheckedId;
				}
				if (CheckedId!=""){
					if (TreeDataStr=="") TreeDataStr=CheckedId;
				    else  TreeDataStr=TreeDataStr+"$"+CheckedId;
			    }
			}
			//下拉框
			if (type=="C"){
				var ComboSelId=$("#"+detailId+"").combobox('getValue');
				//ComboChildJson.push(jQuery.parseJSON('{"id":"' + ComboSelId +'"}'));
				if (ComboDataStr=="") ComboDataStr=ComboSelId;
				else  ComboDataStr=ComboDataStr+"$"+ComboSelId;
			}
			//单选框
			if (type=="CB"){
				var radioName=detailId.split("_")[0]+"_"+(i)+"_CB";
				var CheckedObj=$('input[name='+radioName+']:checked')[0];
				if(CheckedObj!=undefined){
					var CBSelId=CheckedObj.id.split("_")[1];
					if (RadioDataStr=="") RadioDataStr=CBSelId;
					else  RadioDataStr=RadioDataStr+"$"+CBSelId;
				}
			}
			//多选框
			if (type=="CG"){
				var checkboxName=detailId.split("_")[0]+"_"+(i)+"_CG";
				var CheckedObj=$('input[name='+checkboxName+']:checked');
				if (CheckedObj!=undefined){
					for (var m=0;m<CheckedObj.length;m++){
						var CGSelId=CheckedObj[m].id.split("_")[1];
						if (CheckDataStr=="") CheckDataStr=CGSelId;
					    else  CheckDataStr=CheckDataStr+"$"+CGSelId;
					}
				}
			}
		}
	}
	if ((DKBBCRowId=="")&&($dynamic_tr.length>0)){
		var trids=$dynamic_tr[0].id; 
		var DKBBCRowId=trids.split("_")[0];
	}
	if (DKBBCRowId!=""){
		var DiagDisplayName=$("#Form_DiagDesc").val(); //$("#Form_DiagDesc").combobox('getText');
		if (DiagDisplayName==""){
			$.messager.alert("提示","请选择或输入诊断名");
			return false;
		}
		DiagDisplayName=DiagDisplayName.split("(")[0];
		var DiagPNotes=trim($("#DiagPNotes").val());
		var DiagPLinkICDDataArr=$("#DiagPLinkICD").combobox("getData");
		if (DiagPLinkICDDataArr.length>0){
			var linkICDRowid=$("#DiagPLinkICD").combobox("getValue");
			if (linkICDRowid==""){
				$.messager.alert("提示","请选择关联ICD诊断");
			    return false;
			}
			var Find=0;
			for(i=0;i<DiagPLinkICDDataArr.length;i++){
				var cmd="var val=DiagPLinkICDDataArr[i].id";
				eval(cmd);
				if(val==linkICDRowid) {
					Find=1  
					break;
				}
			}
			if (Find==0) linkICDRowid="";
		}else{
			var linkICDRowid="";
		}
		
		var DiagnosPropertyStr=DKBBCRowId+"^"+TreeDataStr+"^"+ComboDataStr+"^"+RadioDataStr+"^"+CheckDataStr+"^"+DiagPNotes+"^"+DiagDisplayName+"^"+linkICDRowid;
	}else{
		var DiagnosPropertyStr="";
	}
	if (DiagnosPropertyStr=="") return "";
	var MainDiaType="N";
	if ($("#Form_MainDiaType").is(":checked")) {MainDiaType="Y";}else{MainDiaType="N";}
	if (MainDiaType=="Y"){
		$("#MainDiaType").attr('checked',true);
	}else{
		$("#MainDiaType").attr('checked',false);
	}
	var DiagnosTypeId=$("#Form_DiagType").combobox("getValue");
	if (DiagnosTypeId==""){
		$.messager.alert("提示","请选择诊断类型");
		return false;
	}else{
		$("#MRDiagType").combobox("setValue",DiagnosTypeId);
	}
	var DiagNotes=$("#Form_DiagNotes").val();
	DiagNotes=DiagNotes.replace(/[\\\@\#\$\%\^\&\*\(\)\{\}\:\"\<\>\?\[\]]/g,"");
	$("#DiagnosNotes").val(DiagNotes);
	if (NeedStolicMast==1){
		var BPSystolic=$("#Form_BPSystolic").val().replace(/(^\s*)|(\s*$)/g,'');	
		var BPDiastolic=$("#Form_BPDiastolic").val().replace(/(^\s*)|(\s*$)/g,'');
		if ((BPSystolic=="")||(BPDiastolic=="")){
			$.messager.alert("提示","请录入完整的血压！","error");
			return false;
		}
		$("#BPSystolic").val(BPSystolic)
	    $("#BPDiastolic").val(BPDiastolic)
	}else{
		var BPSystolic=$("#BPSystolic").val().replace(/(^\s*)|(\s*$)/g,'');	
		var BPDiastolic=$("#BPDiastolic").val().replace(/(^\s*)|(\s*$)/g,'');
	}
	var r = /^[0-9]*[1-9][0-9]*$/ 
	if ((BPSystolic!="")&&(!r.test(BPSystolic))){
		alert("收缩压只能录入数字!");
		// $.messager.alert("提示","收缩压只能录入数字!",function(){
			 $("#BPSystolic").focus();
		 //});
		 return false;
	}
	if ((BPDiastolic!="")&&(!r.test(BPDiastolic))){
		alert("舒张压只能录入数字!")
		//$.messager.alert("提示","舒张压只能录入数字!",function(){
			 $("#BPDiastolic").focus();
	    //});
		 return false;
	}
	/*$("[name^='DiagStatus']").each(function(i){
		if ($("#MainDiaType").is(":checked")){
			var DiagStatusCheckVal=$("#MainDiaType").val();
			if (DiagStatusCheckVal="QZ"){
				DiagnosStatus=DiaD
			}
			if (DiagStatusCheckVal="DZ"){
				DiagnosStatus=DiaW
			}
			if (DiagStatusCheckVal="YZ"){
				DiagnosStatus=DiaH
			}
		}
	})*/
	//var DiagStatus=$("#DiagStatus").combobox("getValue");
	//var Form_MRDiagType=$("#Form_MRDiagType").combobox("getValue");
	//var DiagnosBaseInfo=DiagnosStatus+"^"+Form_MRDiagType;
	//return DiagnosBaseInfo+"#"+DiagnosPropertyStr;
	return DiagnosPropertyStr;
}
function GetDiagBaseInfo(){
	var MainDiaType="N";
	if ($("#Form_MainDiaType").is(":checked")) {MainDiaType="Y";}else{MainDiaType="N";}
	var DiagnosTypeId=$("#Form_DiagType").combobox("getValue");
	var DiagNotes=$("#Form_DiagNotes").val();
	DiagNotes=DiagNotes.replace(/[\\\@\#\$\%\^\&\*\(\)\{\}\:\"\<\>\?\[\]]/g,"");
	var BPSystolic=$("#BPSystolic").val().replace(/(^\s*)|(\s*$)/g,'');	
	var BPDiastolic=$("#BPDiastolic").val().replace(/(^\s*)|(\s*$)/g,'');
	return DiagnosStatus+"^"+MainDiaType+"^"+DiagnosTypeId+"^"+DiagNotes+"^"+BPSystolic+"^"+BPDiastolic;
}
function SetDocSelInfo(){
	var DiagDesc=$('#DiagnosSearch').combogrid('getText');
	$("#Form_DiagDesc").val(DiagDesc);
	/*InitFormMRDiagType();
	if (DiagnosStatus==DiaD){
		var SelDiagStatus="QZ"
	}else if(DiagnosStatus==DiaW){
		var SelDiagStatus="DZ"
	}else{
		var SelDiagStatus="YZ"
	}
	$("[name^='DiagStatus']").each(function(i){
		if ($(this).val()==SelDiagStatus){
			$(this).attr('checked',true);
		}else{
			$(this).attr('checked',false);
		}
	})*/
}
function InitFormMRDiagType()
{
	$("#Form_MRDiagType").combobox({
		multiple:false,
		mode:"remote",
		method: "GET",
		selectOnNavigation:true,
	  	valueField:'DTYPRowid',   
	  	textField:'DTYPDesc',
	  	url:'./dhcdoc.cure.query.combo.easyui.csp',
	  	onBeforeLoad:function(param){
		  	var DiagnosTypeId=$("#MRDiagType").combobox("getValue");
			param.ClassName = 'web.DHCMRDiagnosNew';
			param.QueryName = 'GetDiagnosTypeList';
			param.Arg1 =EpisodeType;
			param.Arg2 =DiagnosTypeId;
			param.ArgCnt =2;
		},
		keyHandler:{
			up: function () {
				var Data=$('#Form_MRDiagType').combobox("getData");
				var CurValue=$('#Form_MRDiagType').combobox("getValue");
                //取得上一行
                for (var i=0;i<Data.length;i++) {
					if (Data[i] && Data[i].DTYPRowid==CurValue) {
						if (i>0) $('#Form_MRDiagType').combobox("select",Data[i-1].DTYPRowid);
						break;
					}
				}
             },
             down: function () {
				var Data=$('#Form_MRDiagType').combobox("getData");
				var CurValue=$('#Form_MRDiagType').combobox("getValue");
                //取得下一行
                for (var i=0;i<Data.length;i++) {
					if (CurValue!="") {
						if (Data[i] && Data[i].DTYPRowid==CurValue) {
							if (i < Data.length-1) $('#Form_MRDiagType').combobox("select",Data[i+1].DTYPRowid);
							break;
						}
					}else{
						$('#Form_MRDiagType').combobox("select",Data[0].DTYPRowid);
						break;
					}
				}
				
            },
			left: function () {
				return false;
            },
			right: function () {
				return false;
            },			
			enter: function () { 
            }
		},
		onShowPanel: function (){
			//选中第一行数据
			var Data=$('#Form_MRDiagType').combobox("getData");
			for (var i=0;i<Data.length;i++) {
				$('#Form_MRDiagType').combobox("select",Data[0].DTYPRowid);
				break;
			}
		}
	});
}
function DiagnosPropertyShow(DiagnosValue,DiagPRowId,DiagnosDesc){
	if (DiagPRowId!=""){
		var ret=tkMakeServerCall("web.DHCMRDiagnos","GetDiagPropertyByRowId",DiagnosValue);
		if (ret==""){
			$.messager.alert("提示","此诊断不存在属性,不能进行查看或修改!");
			return false;
		}else{
			var RetStr = cspRunServerMethod(GetDiagTempData, ret.split("^")[0]);
			if (RetStr!=""){
				var RetStrArr=RetStr.split("^");
				var emptyInfo=RetStrArr[1];
				if (emptyInfo=="") {
					$.messager.alert("提示","此诊断不存在属性,不能进行查看或修改!");
					return false;
				}
			}
		}
		findCondition=DiagnosDesc //$.trim(DiagnosDesc).split("(")[0];
		//$("#Form_DiagDesc").val($.trim(DiagnosDesc));
		$('#ProChangeList').css('display', '');
		ShowFormWindow("",DiagnosValue);
		//$("#ProChangeList").css('display', '');
		LoadDiagProChangeListDataGrid(DiagPRowId);
	}else{
		$.messager.alert("提示","此诊断不存在属性,不能进行查看或修改!");
		return false;
	}
	
}
function LoadDiagProChangeListDataGrid(DiagPRowId)
{
	//if (DiagPRowId=="") return false;
	var queryParams = new Object();
	queryParams.ClassName ='web.DHCMRDiagnos';
	queryParams.QueryName ='GetDiagProChangeLogList';
	queryParams.Arg1 =DiagPRowId;
	queryParams.ArgCnt =1;
	var opts = DiagPropertyChangeLogDataGrid.datagrid("options");
	opts.url = PUBLIC_CONSTANT.URL.QUERY_GRID_URL;
	DiagPropertyChangeLogDataGrid.datagrid('reload', queryParams);
}
function PropertyCheckboxChange(e){
	var targetId=e.target.id;
	targetId=targetId.split("_")[0];
	var checkedFlag=0;
	if ($("#"+e.target.id+"").is(":checked")) checkedFlag=1;
	var $dynamic_tr=$(".dynamic_tr"); 
	for (var i=0;i<($dynamic_tr.length-1);i++){
		var trids=$dynamic_tr[i].id; 
		if (trids.split("_")[1]==targetId){
			if (checkedFlag==1){
				$("#"+trids+"").removeClass("tr_dispaly");
			}else{
				$("#"+trids+"").addClass("tr_dispaly");
			}
			break;
		}
	}
}
//记录基础代码数据使用次数
//TKB_Trem
function DHCDocUseCount(ValueId, TableName) {
    var rtn = tkMakeServerCall("DHCDoc.Log.DHCDocCTUseCount", "Save", TableName, ValueId, session["LOGON.USERID"], "U", session["LOGON.USERID"])
}
