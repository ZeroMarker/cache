/*
Creator:LiangQiang
CreatDate:2014-06-20
Description:患者列表
*/
var frm = dhcsys_getmenuform()
frm.EpisodeID.value=""
var url='dhcpha.clinical.action.csp' ;
var drugSearchLocID=""; //dws 2017-11-16 查找临床药学首页患者后将病区ID传给药历页面
function BodyLoadHandler()
{
   
	$('#patgrid').datagrid({  
			  bordr:false,
			  //fit:true,
			  //fitColumns:true,
			  singleSelect:true,
			  idField:'patadm', 
			  nowrap: false,
			  striped: true, 
			  pagination:true,
			  rownumbers:true,//行号
			  pageSize:30,
			  pageList:[30,60],
			  columns:[[ 
			  {field:'WardID',title:'WardID',width:100,hidden:true},
			  {field:'patward',title:'病区',width:160},
			  {field:'monLevel',title:'监护级别ID',width:80,align:'center',hidden:true},
			  {field:'monLevelDesc',title:'监护级别',width:80,align:'center',
			  		formatter:setMonLevelDescShow
			  },
			  {field:'patbed',title:'床号',width:80},
			  {field:'monCount',title:'监护次数',width:60,formatter:setCellLink,align:'center'},
			  {field:'patno',title:'登记号',width:100,formatter:fomartShowPatInfo}, 
			  {field:'patname',title:'姓名',width:100},   
			  {field:'patsex',title:'性别',width:70},
			  {field:'patage',title:'年龄',width:70},
			  {field:'patheight',title:'身高',width:60},
			  {field:'patweight',title:'体重',width:60},
			  {field:'patindate',title:'入院日期',width:100},
			  {field:'patloc',title:'科室',width:150},
			  {field:'AdmLocID',title:'AdmLocID',width:150,hidden:true},
			  {field:'patroom',title:'病房',width:100},
			  {field:'patdoctor',title:'主治医师',width:80},
			  {field:'patempflag',title:'重点关注',width:80,hidden:true,
			  		formatter:SetCellColor},
			  {field:'patdiag',title:'诊断',width:400},
			  {field:'patadm',title:'adm'},
			  {field:'monSubCId',title:'学科分类',hidden:true},
			  {field:'PatientID',title:'PatientID'}

			  ]],
			  url:url,
			  queryParams: {
					action:'QueryInHosPatList',
					input:""+"^"+session['LOGON.CTLOCID']
			  },
			  toolbar:"#gridtoolbar",
			  onClickRow:function(rowIndex, rowData){ 

                 var patward=rowData.patward;
				 $("#labpatward").text(patward);
				 var patbed=rowData.patbed;
				 $("#labpatbed").text(patbed);
				 var patno=rowData.patno;
				 $("#labpatno").text(patno);
				 var patname=rowData.patname;
				 $("#labpatname").text(patname);
                 var patsex=rowData.patsex;
				 $("#labpatsex").text(patsex);
                 var patage=rowData.patage;
				 $("#labpatage").text(patage);
                 var patheight=rowData.patheight;
				 $("#labpatheight").text(patheight);
				 var patweight=rowData.patweight;
                 $("#labpatweight").text(patweight);
				 var patdoctor=rowData.patdoctor;
				 $("#labpatdoctor").text(patdoctor);
				 var patdiag=rowData.patdiag;
				 if(patdiag.length>40){
					 patdiag=patdiag.substring(0,40)+"......";  //截取前40个字符
					 }
				 $("#labpatdiag").text(patdiag);
                 var patindate=rowData.patindate;
				 $("#labpatindate").text(patindate);
				 var frm=window.parent.parent.document.forms["fEPRMENU"];	//lbb  2018-09-13
				 if(frm.EpisodeID){
					frm.EpisodeID.value=rowData.patadm;
					frm.PatientID.value=rowData.PatientID;
				 }
			  },
			  onDblClickRow:function(rowIndex, rowData){
			  	  showPatPhaSerWin();
			  }	
		  });

         //导出患者查房列表
        $('#btnExport').on('click',BtnExportHandler)

		//加入关注
		$("#btnAddEmp").click(function (e) { 

                var row=$('#patgrid').datagrid('getSelected');
                if (row)
				{
					var adm=row.patadm;
					//AddEmpFlag(adm,'Y');
					SignEmpPat(adm);
				}
				else{
					$.messager.alert('错误提示','请先选择一行记录!',"error");
					return;
				}
                //var rowIndex=$('#patgrid').datagrid('getRowIndex',$('#patgrid').datagrid('getSelected')) 
                

         })


　　　　//取消关注
		$("#btnCancelEmp").click(function (e) { 

                var row=$('#patgrid').datagrid('getSelected');
				if (row)
				{
					var adm=row.patadm ;
					AddEmpFlag(adm,'N');
				}
				else{
					$.messager.alert('错误提示','请先选择一行记录!',"error");
					return;
				}

         })

        //刷新
		$("#btnReload").click(function (e) { 
　　　　　　　　ReLoad();

        })

		//勾选重点关注
		$("#chkempflag").click(function (e) { 
　　　　　　　　ReLoad();

         })


			 
		//查询记录
		/*
		$("#btnWRRec").click(function (e) {
			
			    var data="";

				var row=$('#patgrid').datagrid('getSelected');
				if (row)
				{
					var patward=row.patward;
					var patbed=row.patbed;
					var patname=row.patname;
					var adm=row.patadm ;
					
				}
                data=patward+"^"+patbed+"^"+patname+"^"+adm ;
　　　　　　　　OpenRoomlogWin(data);

         })
         */
        //药历书写
		$("#btnWDRec").bind('click',function(e){
            var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm;  		  //病人ADM
				var PatientID=row.PatientID;  //病人PatientID
				showMedRecordWin(AdmDr,PatientID,drugSearchLocID);
			}else{
				$.messager.alert('错误提示','请先选择一行记录,谢谢!',"error");
			}
         }) 
        
        //用药建议
		$("#btnWUseRec").bind('click',function (e) { 
            var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm; //病人ADM
				showMedSuggestWin(AdmDr); 
			}else{
				$.messager.alert('错误提示','请先选择一行记录,谢谢!',"error");
			}
         })
         
        //不良反应报告
		$("#btnAdrRep").bind('click',function (e) {
			var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm; //病人ADM
				var PatientID=row.PatientID  //病人PatientID
        		showAdrRepWin($(this).text(),"ADR",AdmDr,PatientID);
        	}else{
				$.messager.alert('错误提示','请先选择一行记录,谢谢!',"error");
			}
		})
		
		//用药错误
		$("#btnDrgMis").bind('click',function (e) {
			var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm; //病人ADM
				var PatientID=row.PatientID  //病人PatientID
        		showAdrRepWin($(this).text(),"DRGMIS",AdmDr,PatientID);
        	}else{
				$.messager.alert('错误提示','请先选择一行记录,谢谢!',"error");
			}
		})
		
		 //药品质量
		$("#btnDrgQua").bind('click',function (e) {
			var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm; //病人ADM
				var PatientID=row.PatientID  //病人PatientID
        		showAdrRepWin($(this).text(),"DRGQUA",AdmDr,PatientID);
        	}else{
				$.messager.alert('错误提示','请先选择一行记录,谢谢!',"error");
			}
		})
		
		 //药学查房
		$("#btnPhaWard").bind('click',function (e) {
			var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm; //病人ADM
				var PatientID=row.PatientID  //病人PatientID
        		showAdrRepWin($(this).text(),"PHAWARD",AdmDr,PatientID);
        	}else{
				$.messager.alert('错误提示','请先选择一行记录,谢谢!',"error");
			}
		})
		
		 //医学查房
		$("#btnMedWard").bind('click',function (e) {
			var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm; //病人ADM
				var PatientID=row.PatientID  //病人PatientID
        		showAdrRepWin($(this).text(),"MEDWARD",AdmDr,PatientID);
        	}else{
				$.messager.alert('错误提示','请先选择一行记录,谢谢!',"error");
			}
		})
		
		 //用药教育
		$("#btnMedEducation").bind('click',function (e) {
			var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm; //病人ADM
				var PatientID=row.PatientID  //病人PatientID
        		showAdrRepWin($(this).text(),"MEDEDU",AdmDr,PatientID);
        	}else{
				$.messager.alert('错误提示','请先选择一行记录,谢谢!',"error");
			}
		})
		
		 //药学监护
		$("#btnDrgMontor").bind('click',function (e) {
			var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var AdmDr=row.patadm; //病人ADM
				var PatientID=row.PatientID  //病人PatientID
        		showAdrRepWin($(this).text(),"DRGMON",AdmDr,PatientID);
        	}else{
				$.messager.alert('错误提示','请先选择一行记录,谢谢!',"error");
			}
		})
		
				
		 //药学监护New
		$("#btn_monitor").bind('click',function (e) {
			var row=$('#patgrid').datagrid('getSelected');
			if (row){
				var monAdmDr=row.patadm;   //病人ADM
				var monLevID=row.monLevel; //监护级别
				var monLocID=row.AdmLocID; //科室
				var monSubCId=row.monSubCId; //学科分类
				var monWardID=row.WardID; //病区
				var monLevelDesc=row.monLevelDesc; //监护级别描述
				var LocDesc= tkMakeServerCall("web.DHCSTPHCMEMPPAT","GetLocNameByLocID",session['LOGON.CTLOCID']);
				showEditWin(monLocID,monLevID,monAdmDr,monSubCId,monWardID,monLevelDesc);       		
        	}else{
				$.messager.alert('错误提示','请先选择一行记录,谢谢!',"error");
			}
		})
		
		InitPageQueryDiv(); //初始化页面查询Div
}



function showPatInfo(adm,patno)
{
	createPatInfoWin(adm,patno);
}

function  fomartShowPatInfo(value,rowData,rowIndex){ 

        return "<a href='#' mce_href='#' onclick='showPatInfo("+rowData.patadm+","+rowData.PatientID+");'>"+rowData.patno+"</a>";  

 
}

function  setCellLink(value,rowData,rowIndex){ 
	//将adm和监护级别传递，避免了点击监护次数链接去还没有选中行的问题  qunianepng 2016/11/22
    return "<a href='#' mce_href='#' onclick=\"showPatMonWin('"+rowData.patadm+"','"+rowData.monSubCId+"','"+rowData.monLevelDesc+"')\">"+value+"</a>";  
}
//加入关重
function AddEmpFlag(adm,flag)
{
	        var user=session['LOGON.USERID'] ;
			var input=user+"^"+adm+"^"+flag+"^"+"EMP";
			var data = jQuery.param({ "action":"AddEmpFlag","input":input});

			var request = $.ajax({
				url: url,
				type: "POST",
				async: true,
				data: data,
				dataType: "json",
				cache: false,
				success: function (r, textStatus) {
                     if (r)
                     {
						 ret=r.retvalue; 
                         
						 if (ret=="0")
						 {
							if (flag=="Y")
							{
								$.messager.alert('操作提示','已关注!',"info");
							}else{
								$.messager.alert('操作提示','已取消关注!',"info");
							}
                            ReLoad();
						 }

						 if (ret=="-99")
						 {
							 $.messager.alert('错误提示','之前未关注,不能取消!',"error");
						 }
                     }
					
		                    
				},
				error: function (XMLHttpRequest, textStatus, errorThrown) { 
					  //alert(XMLHttpRequest.readyState); 
					}

			    });


}
					  
//刷新
function ReLoad()
{
	var empflag="N";
	if ($('#chkempflag').attr('checked')) //重点关注
	{
		var empflag="Y" ;
	}
	var input=empflag;

	$('#patgrid').datagrid('load',  {  
				action: 'QueryInHosPatList',
				input:empflag
	});
}

//登记号设置连接 formatter="SetCellColor"  bianshuai 2014-09-22
function SetCellColor(value, rowData, rowIndex)
{
	var html="";
	if(value=="Y"){
		html='<span style="color:red;font-weight:600">已关注</span>';
	}
	return html;
}

/// 弹出用药建议窗口
function showMedSuggestWin(AdmDr)
{
	createMedAdviseWin(AdmDr);
}

/// 弹出药历填写窗口
function showMedRecordWin(AdmDr,PatientID,drugSearchLocID)
{
	createMedRecordWin(AdmDr,PatientID,drugSearchLocID);
}

//编辑窗体
function showAdrRepWin(Title,RepType,AdmDr,PatientID)
{
	if($('#win').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:Title,
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600,
		minimizable:false,					/// 隐藏最小化按钮
		maximized:true,						/// 最大化(qunianpeng 2018/3/10)		
		onClose:function(){
			$('#win').remove();  //窗口关闭时移除win的DIV标签
		}
	});
	var advcode="";
    switch(RepType){
	    case "ADR":
			//maintab="dhcpha.clinical.adrreport.csp";  			/// 不良反应
			//maintab="dhcadv.advreport.csp";  						/// 不良反应
			maintab="dhcadv.layoutform.csp"          /// 不良反应
			advcode="advDrug";
			break;
		case "DRGQUA":
			//maintab="dhcpha.clinical.drugqualityevtreport.csp";		/// 药品质量
			maintab="dhcadv.layoutform.csp";                              /// 药品质量
			advcode="advDrugquality";
			break;
		case "DRGMIS":
			//maintab="dhcpha.clinical.drugmisusereport.csp";	    /// 用药错误
			maintab="dhcadv.medsafetyreport.csp";                   /// 用药错误
			break; 
		case "PHAWARD":
			maintab="dhcpha.clinical.phawardround.csp";				/// 药学查房
			break;
		case "MEDWARD":
			maintab="dhcpha.clinical.medwardround.csp";				/// 医学查房
			break;
		case "MEDEDU":
			maintab="dhcpha.clinical.mededucation.csp";				/// 用药教育
			break;
		case "DRGMON":
			maintab="dhcpha.clinical.drugmontor.csp";				/// 药学监护
			break;
    }

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+maintab+'?PatientID='+PatientID+'&EpisodeID='+AdmDr+'&frmflag='+1+'&code='+advcode+'&quoteflag='+1+'"> </iframe>';
	$('#win').html(iframe);
	$('#win').window('open');
	/*
	window.open('dhcpha.clinical.adrreport.csp?PatientID='+22+'&EpisodeID='+1+'','','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,width=1250,height=570,left=80,top=40');
	*/
}

///标注重点患者 2015-1-6 bianshuai
function SignEmpPat(admDr)
{
	$('#empatwin').css("display","block");
	$('#empatwin').dialog({
		title:"标记患者监护级别",
		collapsible:false,
		border:false,
		closed:"true",
		width:300,
		height:460,
		buttons:[{
				text:'保存',
				iconCls:'icon-save',
				handler:function(){
					saveEmPat(admDr);
					$('#patgrid').datagrid('reload');  //qunianpeng 2016-08-04
					}
			},{
				text:'关闭',
				iconCls:'icon-cancel',
				handler:function(){
					$('#empatwin').dialog('close');
					$("#empatwin").css("display","none");
					}
			}]
	});
	$("#stdate").datebox("setValue", formatDate(0));
	$("#sttime").timespinner('setValue', formatCurrTime());
	$("#enddate").datebox("setValue", "");
	$("#endtime").timespinner('setValue', "");
	$("#user").combobox('setValue',"");
	$("#remark").val("");
	$("#reason").val("");
	$("#empPatID").val("");
	var panelHeightOption = {panelHeight : "auto"};
	/* 设置监控级别 */
	var monLevCombobox = new ListCombobox("monlevel",url+'?action=SelMonLevel','',panelHeightOption);
	monLevCombobox.init();
	/* 转换级别 */
	var trmLevCombobox = new ListCombobox("trmlevel",url+'?action=SelMonLevel','',panelHeightOption);
	trmLevCombobox.init();
	$('#trmlevel').combobox({
		disabled:true
	});
	
	//用户
	$("#user").combobox({
		panelHeight:"auto",  //设置容器高度自动增长
		onShowPanel:function(){
			$('#user').combobox('reload',url+'?action=SelUserByGrp&grpId='+session['LOGON.GROUPID'])
		}
	});
	
	var row=$('#patgrid').datagrid('getSelected');
	if(row.monLevel==""){
		$('#user').combobox({disabled:true});
		$("#user").combobox('setValue',session['LOGON.USERID']);
		$("#user").combobox('setText',session['LOGON.USERNAME']);
		$("#monlevel").combobox({disabled:false});  //qunianpeng 2016-08-04
		$("#enddate").datebox({disabled:true});     //qunianpeng 2016-08-17
		$("#endtime").timespinner({disabled:true});
	}else{
		getEmPatInfo(admDr);   //加载重点患者信息
	}
	$('#empatwin').dialog('open');
}

//保存重点患者
function saveEmPat(EpisodeID)
{
	var stdate = $('#stdate').combobox('getValue');      //开始日期
	var sttime = $('#sttime').timespinner('getValue');   //开始时间
	var user = $("#user").combobox('getValue');  		 //责任药师
	var monlevel = $("#monlevel").combobox('getValue');  //监控级别
	var trmlevel = $("#trmlevel").combobox('getValue');  //转为级别
	var enddate = $('#enddate').combobox('getValue');    //结束日期
	var endtime = $('#endtime').timespinner('getValue'); //结束时间
	var reason=$('#reason').val(); //原因
	var remark=$('#remark').val(); //备注
	
	var empPatID = $('#empPatID').val(); //重点患者记录ID
	if (empPatID==""){
		
		if((stdate=="")||(sttime=="")){
			$.messager.alert('操作提示','开始日期或时间不能为空!',"info");
			return;
		}

		if(monlevel==""){
			$.messager.alert('操作提示','监控级别不能为空!',"info");
			return;
		}
	}
	else{

		if((enddate=="")||(endtime=="")){
			$.messager.alert('操作提示','结束日期或时间不能为空!',"info");
			return;
		}
		if(ChangeTimeStamp(stdate,sttime)>ChangeTimeStamp(enddate,endtime)){	 /// 修改日期比较 qunianpeng 2018/3/21		 
		     $.messager.alert('操作提示','结束日期或时间不能小于开始日期或时间!',"info");
		     return;
		} 
		monlevel="";
	}
	
	//监护数据列表
	var empdatalist = stdate+"^"+sttime+"^"+EpisodeID+"^"+monlevel+"^"+user+"^"+remark+"^"+enddate+"^"+endtime+"^"+reason;
	//保存
    var saveflag = saveEmPatAjax(empPatID,empdatalist,monlevel);
    
    ///切换监护级别
    if (trmlevel != ""){
	    monlevel = trmlevel;
	    var empdatalist = enddate+"^"+endtime+"^"+EpisodeID+"^"+trmlevel+"^"+user+"^"+remark+"^^^"+reason;
		saveflag = saveEmPatAjax("",empdatalist);
	}

	if (saveflag){
		var row=$('#patgrid').datagrid('getSelected');
		var index = $("#patgrid").datagrid('getRowIndex', row);   //获取选定行的索引
		$('#patgrid').datagrid('updateRow',{index: index,row:{monlevel:monlevel}});
		/// 关闭窗口
		$('#empatwin').dialog('close');  
	}
}

///保存
function saveEmPatAjax(empPatID,empDataList){
	/// 保存Ajax调用
    $.ajax({type: "POST", url: url, data: "action=saveEmpPat&empPatID="+empPatID+"&empPatList="+empDataList,dataType: "json",
       success: function(val){
	      if (val=="0") {
		     return true;
	      }else{
		  	 $.messager.alert("提示:",val,"error");
		  	 return false;
		  }
       },
       error: function(){
	       $.messager.alert("提示:","链接出错！","error");
	       return false;
	   }
    });	
    return true;
}

// 获取重点患者监护信息
function getEmPatInfo(EpisodeID)
{
   if(EpisodeID==""){return;}
   
   $.ajax({
	   type: "POST",
	   url: url,
	   data: "action=getEmpPatInfo&AdmDr="+EpisodeID,
	   //dataType: "json",
	   success: function(val){
	
			var tmp=val.split("^");
			//病人信息
			$('#empPatID').val(tmp[0]); //重点患者记录ID
			$("#stdate").datebox("setValue", tmp[1]);   	  //开始日期
			$("#sttime").timespinner('setValue', tmp[2]);     //开始时间
			$("#monlevel").combobox('setValue',tmp[3]);       //监护级别
			$('#trmlevel').combobox({disabled:false});
			$('#user').combobox({disabled:true});
			$("#user").combobox('setValue',tmp[4]);    //责任药师
			$("#user").combobox('setText',tmp[5]);     //责任药师
				if(($("#remark").val()!="")&&($("#reason").val()!="")){   //liyarong 2016-09-12
				$("#remark").val("");
				$("#reason").val("");
				}
			$("#remark").val(tmp[6]);  //备注
			$("#reason").val(tmp[7]);  //原因  
			if(tmp[3]!=""){								//qunianpeng  2016-08-04
				$("#monlevel").combobox({disabled:true});
				$("#monlevel").combobox('setValue',tmp[3]);
				$("#enddate").datebox({disabled:false});     //qunianpeng 2016-08-17
				$("#endtime").timespinner({disabled:false});
			}
	   }
	})
}

// 格式化监护级别设置颜色
function setMonLevelDescShow(value,rowData,rowIndex){
	if(value == "") {return;}
	return '<span style="color:'+ value.split("@")[1] +';font-weight:bold;">'+ value.split("@")[0] +'</span>';
}

/// 初始化条件查询信息
function InitPageQueryDiv()
{
	//病区
/* 	$('#ward').combobox({
		onShowPanel:function(){
			$('#ward').combobox('reload',url+'?action=SelAllWard')
		}
	}); */
	
	$('#ward').combobox({ //qunianpeng 2017/8/14 支持拼音码和汉字
		mode:'remote',
		onShowPanel:function(){ 
			$('#ward').combobox('reload',url+'?action=GetAllWardNewVersion&hospId='+session['LOGON.HOSPID']+'  ')
		}
	});
	$("#tip").css({
		top : ($("#tip").offset().top + 30) + 'px',   
		left : ($("#tip").offset().left - 30)+ 'px'
    })
	$("#tip").animate({opacity: 0}, 800).hide();
	
	//查询条件设置
	$("a:contains('查询')").bind('click',function(){
		
		$("#tip").css({
			top : ($(this).offset().top + 30) + 'px',   
			left : ($(this).offset().left - 30)+ 'px'
        })
		$("#tip").animate({opacity: 1}, 800).show()
	})
	
	//提交
	$("a:contains('提交')").bind('click',function(){
		LoadPatList();
	})
	
	//取消
	$("a:contains('关闭')").bind('click',function(){
		$('#ward').combobox("setValue","");
		$('#patno').val("");
		$("#tip").animate({opacity: 0}, 800).hide();
	})
	
	//返回
	$("a:contains('返回')").bind('click',function(){
		LoadPatListBack();
	})
	//登记号绑定回车事件
    $('#patno').bind('keypress',function(event){
        if(event.keyCode == "13"){
			LoadPatList();
        }
    });
}

/// 重新加载患者列表
function LoadPatList()
{
	var WardID=$('#ward').combobox('getValue'); // 病区ID
	var PatNo=$.trim($("#patno").val());        // 登记号
	drugSearchLocID=WardID;
	if(PatNo==""&WardID==""){
		 $.messager.alert("提示:","登记号为空或者病区为空，请重新输入！");
	       return;
	}
	if(PatNo!=""){
		//登记号补0
		var patLen = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetPatRegNoLen");
		var plen = PatNo.length;
		if (plen>patLen){
		   $.messager.alert("提示:","登记号录入错误！");
	       return;
		}
		for (i=1;i<=patLen-plen;i++){
		    PatNo="0"+PatNo;  
	    }
	       var patFlag=tkMakeServerCall("web.DHCSTPHCMCOMMON", "checkpatFlag",PatNo,session['LOGON.HOSPID'])
			if(patFlag==1){
			    $.messager.alert("提示:","该患者不是本院区的患者");
			       return;
			}
			else if(patFlag==2){
			    $.messager.alert("提示:","该患者在本院区没有住院记录");
			       return;
			}
	}
	$("#patno").val(PatNo);
	$('#patgrid').datagrid('load',{  
		action: 'QueryInHosPatList',
		input:""+"^^"+WardID+"^"+PatNo
	});
}

/// 重新加载患者列表
function LoadPatListBack()
{
	var LocID=session['LOGON.CTLOCID']; //登录科室ID
	$('#patgrid').datagrid('load',{
		action: 'QueryInHosPatList',
		input:""+"^"+LocID+"^"+""
	});
}

/// 药学监护
function showEditWin(monLocID, monLevID, monAdmID, monSubCId, monWardID,monLevelDesc){
	monLevelDesc=escape(monLevelDesc)
	if(monLevID == ""){
		$.messager.alert('提示','<font style="color:red;font-weight:bold;font-size:15px;">请标注监护级别后重试！</font>','warning');
		return;
	}
	if($('#monwin').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="monwin"></div>');
	$('#monwin').window({
		title:"药学监护",
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600,
		minimizable:false,						/// 隐藏最小化按钮
		maximized:true,							/// 最大化(qunianpeng 2018/3/10)		
		onClose:function(){
			$('#monwin').remove();  			/// 窗口关闭时移除win的DIV标签
		}
	});

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.pharcaredit.csp?monLocID='+monLocID+'&monLevID='+monLevID+'&monAdmID='+monAdmID+'&monSubCId='+monSubCId+'&monWardID='+monWardID+'&monLevelDesc='+monLevelDesc+' "></iframe>';
	$('#monwin').html(iframe);
	$('#monwin').window('open');
}
//用于在子窗口刷新数据表格  qunianpeng 2016-08-08
function loadParWin(){
	$('#monwin').window('close');
	$('#patgrid').datagrid('reload');
}

/// 病人监护窗口
function showPatMonWin(monAdmID,monSubClassId,monLevelDesc){
	monLevelDesc=escape(monLevelDesc)
	if (!monAdmID){
		$.messager.alert('错误提示','请先选择一行记录,谢谢!',"error");
		return ;
	}  //将adm和监护级别传递进来，去掉重新获取选中行，避免了点击监护次数链接却还没有选中行的问题  qunianepng 2016/11/22
	if($('#monwin').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="monwin"></div>');
	$('#monwin').window({
		title:"监护信息查询",
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600,		
		minimizable:false,					/// 隐藏最小化按钮
		maximized:true,						/// 最大化(qunianpeng 2018/3/17)
		onClose:function(){
			$('#monwin').remove();  //窗口关闭时移除win的DIV标签
		}
	});

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.pharcarequery.csp?monAdmID='+monAdmID+'&monSubClassId='+monSubClassId+'&monLevelDesc='+monLevelDesc+' "></iframe>';
	$('#monwin').html(iframe);
	$('#monwin').window('open');
}


/// 病人药学服务窗口
function showPatPhaSerWin(){
	var monAdmID = "";
	var monSubClassId = "";
	var EpisodeID = "";
	var rowData=$('#patgrid').datagrid('getSelected');
	if (rowData){
		monAdmID = rowData.patadm;
		monSubClassId = rowData.monSubCId;
		EpisodeID = rowData.patadm;
	}else{
		$.messager.alert('错误提示','请先选择一行记录,谢谢!',"error");
	}
	
	if($('#monwin').is(":visible")){return;}  //窗体处在打开状态,退出
	$('body').append('<div id="monwin"></div>');
	$('#monwin').window({
		title:"药学服务查询",
		collapsible:true,
		border:false,
		minimizable:false,
		closed:"true",
		width: $(window).width()*0.9,
		height: $(window).height()*0.9,
		onClose:function(){
			$('#monwin').remove();  //窗口关闭时移除win的DIV标签
		}
	});
	var src = 'dhcpha.clinical.perpharservice.csp?EpisodeID='+EpisodeID;
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+ src +'"></iframe>';
	$('#monwin').html(iframe);
	$('#monwin').window('open');
	
	//window.open('dhcpha.clinical.perpharservice.csp?EpisodeID='+EpisodeID+'', 'newwindow', 'height=500, width=1300, top=0, left=0, toolbar=no, menubar=no, scrollbars=no, resizable=yes, location=no');
}

/// 将日期转成时间戳 用于时间大小比较 qunianpeng 2018/3/21
function ChangeTimeStamp(date,time){

	/// 库里有两种日期格式 日/月/年   年-月=日  需要先将/格式转化为年/月/日
	if (date.indexOf("/")>0){
		var dateArray = date.split("/"); 
		date = dateArray[2]+"/"+dateArray[1]+"/"+dateArray[0];
	}
	var datetime = date +" "+ time;
	var timestamp = Date.parse(new Date(datetime.replace(/-/g, '/')));  
	timestamp = timestamp / 1000;  
	return timestamp;
}
//导出
function BtnExportHandler(){
	var p_URL='dhccpmrunqianreport.csp?reportName=DHCST_PHCM_InHosPatInfo.raq';
	window.open(p_URL,"","top=20,left=20,width=930,height=660,scrollbars=1"); 
      
}