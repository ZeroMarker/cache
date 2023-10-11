function pagerFilter(data){
	if (typeof data.length == 'number' && typeof data.splice == 'function'){	// is array
		data = {
			total: data.length,
			rows: data
		}
	}
	var dg = $(this);
	var opts = dg.datagrid('options');
	var pager = dg.datagrid('getPager');
	//debugger;
	pager.pagination({
		showRefresh:false,
		onSelectPage:function(pageNum, pageSize){
			opts.pageNumber = pageNum;
			opts.pageSize = pageSize;
			pager.pagination('refresh',{
				pageNumber:pageNum,
				pageSize:pageSize
			});
			dg.datagrid('loadData',data);
			dg.datagrid('scrollTo',0); //滚动到指定的行  
		}
	});
	if (!data.originalRows){
		data.originalRows = (data.rows);
	}
	if (opts.pagination){
		if (data.originalRows.length>0) {
			var start = (opts.pageNumber==0?1:opts.pageNumber-1)*parseInt(opts.pageSize);
			if ((start+1)>data.originalRows.length){
				//取现有行数最近的整页起始值
				start=Math.floor((data.originalRows.length-1)/opts.pageSize)*opts.pageSize;
				opts.pageNumber=(start/opts.pageSize)+1;
			}
			//解决页码显示不正确的问题
			$.extend($.data(pager[0], "pagination").options,{pageNumber:opts.pageNumber});
			
			var end = start + parseInt(opts.pageSize);
			data.rows = (data.originalRows.slice(start, end));
		}
	}
	return data;
}
function Util_InitHospList(code)
{
	var hospStr=session['LOGON.USERID']+"^"+session['LOGON.GROUPID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.HOSPID']
	var hospComp = GenHospComp(code,hospStr);
	hospComp.jdata.options.onSelect = function(e,t){
		Init();
	}
	hospComp.jdata.options.onLoadSuccess= function(data){
		Init();
	}
}

function Util_GetSelHospID(){
	var HospID="";
	if($('#_HospList').length>0){
		HospID=$HUI.combogrid('#_HospList').getValue();
	}
	else if($('#_HospUserList').length>0){
		HospID=$HUI.combogrid('#_HospUserList').getValue();
	}
	if ((!HospID)||(HospID=="")) {
		HospID=session['LOGON.HOSPID'];
	}
	return HospID;
}

(function ($) {
	//datagrid 扩展
	$.extend($.fn.datagrid.methods, {
		editCell: function (jq, param) {
			return jq.each(function () {
				var opts = $(this).datagrid('options');
				var fields = $(this).datagrid('getColumnFields', true).concat($(this).datagrid('getColumnFields'));
				for (var i = 0; i < fields.length; i++) {
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor1 = col.editor;
					if (fields[i] != param.field) {
						col.editor = null;
					}
				}
				$(this).datagrid('beginEdit', param.index);
				for (var i = 0; i < fields.length; i++) {
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor = col.editor1;
				}
			});
		},
		endEditCell: function (jq, param) {
			return jq.each(function () {
				var thisCellEditor = null;
				var opts = $(this).datagrid('options');
				var fields = $(this).datagrid('getColumnFields', true).concat($(this).datagrid('getColumnFields'));
				for (var i = 0; i < fields.length; i++) {
					var col = $(this).datagrid('getColumnOption', fields[i]);
					if (fields[i] == param.field) {
						thisCellEditor = col.editor;
						col.editor = null;
						break;
					}
				}
				$(this).datagrid('endEdit', param.index);
				for (var i = 0; i < fields.length; i++) {
					var col = $(this).datagrid('getColumnOption', fields[i]);
					if (fields[i] == param.field) {
						col.editor = thisCellEditor;
						break;
					}
				}
			});
		},
		autoMergeCells: function (jq, fields) {    //自动合并datagrid相同列
			return jq.each(function () {
				var target = $(this);
				if (!fields) {
					fields = target.datagrid("getColumnFields");
				}
				var rows = target.datagrid("getRows");
				var i = 0;
				var j = 0;
				var temp = {};
				for (i; i < rows.length; i++) {
					var row = rows[i];
					j = 0;
					for (j; j < fields.length; j++) {
						var field = fields[j];
						var tf = temp[field];
						if (!tf) {
							tf = temp[field] = {};
							tf[row[field]] = [i];
						} else {
							var tfv = tf[row[field]];
							if (tfv) {
								tfv.push(i);
							} else {
								tfv = tf[row[field]] = [i];
							}
						}
					}
				}
				$.each(temp, function (field, colunm) {
					$.each(colunm, function () {
						var group = this;
						if (group.length > 1) {
							var before;
							var after;
							var megerIndex = group[0];
							for (var i = 0; i < group.length; i++) {
								before = group[i];
								after = group[i + 1];
								if (after && (after - before) == 1) {
									continue;
								}
								var rowspan = before - megerIndex + 1;
								if (rowspan > 1) {
									target.datagrid('mergeCells', {
										index: megerIndex,
										field: field,
										rowspan: rowspan
									});
								}
								if (after && (after - before) != 1) {
									megerIndex = after;
								}
							}
						}
					});
				});
			});
	    }
	});
})(jQuery);
var com_Util=(function(){
	/**
	 * 创建一个模态 Dialog
	 * @param id divId
	 * @param _url Div链接
	 * @param _title 标题
	 * @param _width 宽度
	 * @param _height 高度
	 * @param _icon ICON图标
	 * @param _btntext 确定按钮text
    */
	function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event,_closeBtn){
	    if(_btntext==""){
		   var buttons=[];
	   }else{
		   var buttons=[{
				text:_btntext,
				iconCls:_icon,
				handler:function(){
					if(_event!="") eval(_event);
				}
			}]
	   }
	   if(_closeBtn=="Y"){
		   buttons.push({
			   text:'关闭',
				iconCls:'icon-w-close',
				handler:function(){
	   				destroyDialog(id);
				}
		   });
	   }
	    
	    $("body").append("<div id='"+id+"' class='hisui-dialog'></div>");
	    if (_width == null)
	        _width = 800;
	    if (_height == null)
	        _height = 500;
	    $("#"+id).dialog({
	        title: $g(_title),
	        width: _width,
	        height: _height,
	        cache: false,
	        iconCls: _icon,
	        collapsible: false,
	        minimizable:false,
	        maximizable: false,
	        resizable: false,
	        modal: true,
	        closed: false,
	        closable: true,
	        content:_content,
	        buttons:buttons,
	        onClose:function(){
		        destroyDialog(id);
		    }
	    });
	}
	function destroyDialog(id){
	   //移除存在的Dialog
	   $("body").remove("#"+id); 
	   $("#"+id).dialog('destroy');
	}
	
	function SetComboVal(id,val,text,NotSetNull){
		if (($("#"+id).length) && ($("#"+id).length > 0)){
			var className=$("#"+id).attr("class")
			if(typeof className =="undefined"){
				return;
			}
			
			if((className.indexOf("hisui-lookup")>=0)||(className.indexOf("lookup-text")>=0)){
				$("#"+id).lookup("setValue",val)
    			.lookup("setText",text);
			}else if(className.indexOf("hisui-combobox")>=0){
				var optobj=$("#"+id).combobox("options");
				var mulval=optobj.multiple;
				var data=$("#"+id).combobox("getData");
				if ($.hisui.indexOfArray(data,optobj.valueField,val)<0) {
					if(NotSetNull!="Y"){$("#"+id).combobox("select","");}
				}else{
					$("#"+id).combobox("select",val);
				}
			}else if(className.indexOf("hisui-datebox")>=0){
				$HUI.datebox("#"+id).setValue(val); 
			}else if(className.indexOf("hisui-numberbox")>=0){
				$HUI.numberbox("#"+id).setValue(val); 
			}else if(className.indexOf("hisui-checkbox")>=0){
				$HUI.checkbox("#"+id).setValue(val); 
			}else{
				$("#"+id).val(val)
			}
		}
	}
	
	
	function InitPatientInfo(EpisodeID){
		var DCARowId="";
		if(EpisodeID!=""){
			$.m({
				ClassName:"DHCDoc.DHCDocCure.Apply",
				MethodName:"GetPatientBaseInfo",
				'DCARowId':DCARowId,
				'adm':EpisodeID,
				'DataType':"JSON"
			},function testget(value){
				if (value!=""){
					DisplayPatInfo(value);
				}
			});
		}	
	}
	function DisplayPatInfo(val){
		var PatInfoObj=eval("("+val+")");
		if(typeof(PatInfoObj.baseInfoName)=='undefined'){return}
		var PatNo=PatInfoObj.baseInfoRegNo;
		var PatName=PatInfoObj.baseInfoName;
		var PatSex=PatInfoObj.baseInfoSex;
		var PatAge=PatInfoObj.baseInfoAge;
		var PatType=PatInfoObj.baseInfoInsu;
		var patBed=PatInfoObj.baseInfoBedno;
		if(patBed=="")patBed="-";
		var PatTel="";
		var PatAddress="";
		var PatNoi=PatNo
		var InfoAdmDays=PatInfoObj.baseInfoAdmDays;
		var charge="￥"+PatInfoObj.baseInfoCharge;
		var Diagnosis=PatInfoObj.baseInfoDiag;
		var IconProfile=PatInfoObj.baseIconProfile;
		$("#patNo").prop("innerText",PatNoi);
		$("#patName").prop("innerText",PatName);
		$("#patSex").prop("innerText",PatSex);
		$("#patSeximg :last-child").remove();
		if(PatSex=="男"){
			var imghtml="<img src='../images/man.png' alt=''/>"
			$("#patSeximg").append(imghtml)
		}else if(PatSex=="女"){
			var imghtml="<img src='../images/woman.png' alt=''/>";
			$("#patSeximg").append(imghtml)
		}
		$("#patAge").prop("innerText",PatAge);
		$("#patType").prop("innerText",PatType);
		$("#patBed").prop("innerText",patBed);
		$("#charge").prop("innerText",charge);
		$("#Diagnosis").prop("innerText",Diagnosis);
	}
	
	function getConfigUrl(userId,groupId,ctlocId){
		return {title:$g("界面配置"),url:"doccure.config.pagelayout.hui.csp?",width:'80%',height:400};	
	}
	
	function convertImgToBase64(file,callback,picobj){
		try{
			var reader = new FileReader();
			var AllowImgFileSize = 2100000; //上传图片最大值(单位字节)（ 2 M = 2097152 B ）超过2M上传失败
			var imgUrlBase64;
			var base64Img="";
			if (file) {
				var fname=file.name.toLowerCase();
				if(!/.(gif|jpg|jpeg|png|gif|jpg|png)$/.test(fname)){
		            $.messager.alert('提示',"上传图片类型必须是.gif,jpeg,jpg,png中的一种!");
		            return false;
		        }
				//将文件以Data URL形式读入页面  
				imgUrlBase64 = reader.readAsDataURL(file);
				reader.onload = function (e) {
					if (AllowImgFileSize != 0 && AllowImgFileSize < reader.result.length) {
						$.messager.alert('提示',picname+"请上传不大于2M的图片！");
						return false;
					}else{
						base64Img=reader.result;
						callback.call(this, base64Img,picobj);
						return true;
					}
				}
			}else{
				$.messager.alert('提示',picname+"获取文件错误!");
				return false;
			}
			return true;
		}catch(e){
			$.messager.alert('提示',e.message);
			return false;
		}
	}
	
	function ShowDescPopover(that,content){
		var contentFlag=0; //为0 代表显示的是医嘱列信息 为1代表无论长度都要显示
		if ((contentFlag==0)&&($(that).width()<160)) return false;
		var MaxHeight=20;
		MaxHeight='auto',placement="top";
		$(that).webuiPopover({
			title:'',
			content:content,
			trigger:'hover',
			placement:placement,
			style:'inverse',
			height:MaxHeight
			
		});
		$(that).webuiPopover('show');
	}
	
	function InitCurePatientDataGrid(LoadFun){
		var columns=[[
			{field:'PatientID',title:'PatientID',width:10,hidden:true},
			{field:'PatientLabel',title:'患者信息',width:205,formatter:setCellLabel,align:'left'},
		]];
		var CurePatientDataGrid=$("#tabCurePatientList").datagrid({  
			fit : true,
			width : 'auto',
			border : false,
			striped : true,
			singleSelect : true,
			fitColumns : false,
			autoRowHeight : true,
			loadMsg : '加载中..',  
			pagination : true,  
			pageSize : 20,
			pageList : [10,20,50],
			rownumbers : true, 
			idField:"PatientID",
			columns :columns,
			onLoadSuccess:function(data){
			    ///  隐藏分页图标
	            $('.patlist-panel .pagination-info').hide();	
			},
			onBeforeSelect:function(index, row){
				var oldSelRow=$(this).datagrid('getSelected');
				var oldSelIndex=$(this).datagrid('getRowIndex',oldSelRow);
				if (oldSelIndex==index){
					LoadFun("","","",{
						NotReloadPatData:"N"	
					});
				}
			},
			onSelect: function (rowIndex, rowData) {
				var OldPatientID=$("#PatientID").val();
				$("#PatientID").val(rowData.PatientID);
				LoadFun("","","",{
					NotReloadPatData:"Y"	
				});
				$("#PatientID").val(OldPatientID);
	        }
		});	
		return CurePatientDataGrid;
	}
	function setCellLabel(value, rowData, rowIndex){
		var color="#000"
		var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;color:'+color+'">'+ rowData.PatientName +" "+rowData.PatientNo+'</h3>';
		htmlstr = htmlstr +'<h3 style="position:absolute;right:0;color:red;background-color:transparent;"><span style="font-size:16px;">'+""+ '</span></h3><br>';
		htmlstr = htmlstr + '<h4 style="float:left;background-color:transparent;color:#666666;">'+rowData.PatOther+'</h4>';
		htmlstr = htmlstr +'</div>';
		return htmlstr;
	}
	function CheckComboxSelData(id,selId){
		var Find=0;
		var Data=$("#"+id).combobox('getData');
		var opts=$("#"+id).combobox('options');
		var opt_text=opts.textField;
		var opt_val=opts.valueField;
		for(var i=0;i<Data.length;i++){
			var CombValue=Data[i][opt_val]
			var CombDesc=Data[i][opt_text]
			if(selId==CombValue){
				selId=CombValue;
				Find=1;
				break;
			}
		}
		if (Find=="1") return selId
		return "";
	}
	function GetSessionStr() {
	    var Str = "";
	    Str = session['LOGON.USERID'];
	    Str += "^" + session['LOGON.GROUPID'];
	    Str += "^" + session['LOGON.CTLOCID'];
	    Str += "^" + session['LOGON.HOSPID'];
	    Str += "^" + session['LOGON.WARDID'];
	    Str += "^" + session['LOGON.LANGID'];
	    return Str;
	}
	return{
		"createModalDialog":createModalDialog,
		"destroyDialog":destroyDialog,
		"InitPatientInfo":InitPatientInfo,
		"SetComboVal":SetComboVal,
		"getConfigUrl":getConfigUrl,
		"convertImgToBase64":convertImgToBase64,
		"ShowDescPopover":ShowDescPopover,
		"InitCurePatientDataGrid":InitCurePatientDataGrid,
		"CheckComboxSelData":CheckComboxSelData,
		"GetSessionStr":GetSessionStr
	}
})()

var com_withApplyFun=(function(){
	function addExecOrderHandler(){
		com_Util.destroyDialog("CureOrdDiag");
	   	var html="<div id='DiagWin' style=''>"
			html +="	<table class='search-table' cellpadding='5' style='margin:0 auto;border:none;'>"
			html +="	 <tr>"
			html +="	 <td class='r-label'>"
			html +="	 "+$g("要求执行日期")
			html +="	 </td>"
			html +="	 <td>"
			html +="	 <input id='winRunOrderDate' type='text' class='hisui-datebox' required='required'></input>"
			html +="	 </td>"
			html +="	 </tr>"
			html +="	 <tr>"
			html +="	 <td class='r-label'>"
			html +="	 "+$g("要求执行时间")
			html +="	 </td>"
			html +="	 <td>"
			html +="	 <input id='winRunOrderTime' class='hisui-combobox'/> "
			html +="	 </td>"
			html +="	 </tr>"
			html +="	 </tr>"
		   	html +="	</table>"
	   		html += "</div>"	
		var iconCls="icon-w-ok";
	    com_Util.createModalDialog("CureOrdDiag","增加执行医嘱", 380, 260,iconCls,"确定",html,"com_withApplyFun.MulOrdDealWithCom('Addexec')","Y");
	    var o=$HUI.datebox('#winRunOrderDate');
	    o.setValue(ServerObj.CurrentDate);
	    var cbox = $HUI.combobox("#winRunOrderTime", {
		    width:'151',
			editable: true,
			multiple:false,
			mode:"remote",
			method: "GET",
			selectOnNavigation:true,
		  	valueField:'id',
		  	textField:'text',
		  	data:ServerObj.IntervalTimeListJson, //eval("("+ServerObj.IntervalTimeListJson+")"),
		  	onLoadSuccess:function(){
				var sbox = $HUI.combobox("#winRunOrderTime");
				sbox.setValue("");
			}
		});
	    $('#winRunOrderTime').next('span').find('input').focus();
	}
	function addExecOrderShowHandler(rowIndex,record){
		var title="";
		var orderStatus = record.OrdStatusCode;
		var PHFreqCode = record.OrdFreqCode;
		var ApplyStatus= record.ApplyStatus ;
		var ApplyExecFlag= record.ApplyExecFlag;
		var ApplyOrdQty= record.OrdQty;
		var ApplyAppedTimes= record.ApplyAppedTimes;
		var ApplyFinishTimes= record.ApplyFinishTimes;
		var ApplyNoFinishTimes= record.ApplyNoFinishTimes;
		var ApplyStatusCode=record.ApplyStatusCode;
		if((orderStatus != "V")&&(orderStatus != "E")) {
			title = $g("医嘱非核实状态,不能增加!");
			return title;
		}else if(ApplyStatusCode== "C"){
			title = $g("治疗申请已撤销,不能增加!");
			return title ;
		}else if(ApplyStatusCode== "F"){
			title = $g("治疗申请已完成,不能增加!");
			return title ;
		}else if(PHFreqCode.toLocaleUpperCase() != "PRN"){
			title = $g("prn医嘱才能增加!");
			return title ;
		}/*else if(ApplyExecFlag!="Y"){
			title = $g("非直接执行医嘱，不能增加!");
			return title ;
		}*/else if(parseInt(ApplyOrdQty)<=parseInt(ApplyAppedTimes+ApplyFinishTimes+ApplyNoFinishTimes)){
			title = $g("已达申请数量上限,不能继续增加!");
			return title ;
		}
		return title;	
	}

	function AddOrderClick(DataGrid){
		var rows = DataGrid.datagrid("getSelections");
		if (rows.length==0) {
			$.messager.alert("提示","请选择申请单!","info");
			return false;
		}
		var OEOrdItemIDArr=[];
		for (var i=0;i<rows.length;i++) {
			var OrderId=rows[i].OrderId;
			OEOrdItemIDArr.push(OrderId);
		}
		var OEOrdItemIDs=OEOrdItemIDArr.join("^");
		var url = "ipdoc.nursebatchsupplementord.hui.csp?EpisodeID=&OEOrdItemIDs="+OEOrdItemIDs+"&NotUnSelectPat=Y"+"&NotLinkMaster=Y"+"&NotAdmTypeLimit=Y";
		websys_showModal({
			url: url,
			width: '97%',
			height: '85%',
			iconCls:"icon-w-paper",
			title: $g('补录费用'),
			closed: true,
			modal:true,
			onClose:function(){
				//解除患者锁
	    		tkMakeServerCall("web.DHCDocOrderCommon","OrderEntryClearLock");
			}
		});
	}
	
	function MulOrdDealWithCom(type){
	   var date="",time="";
	   var ExpStr=session['LOGON.USERID']+"^"+session['LOGON.CTLOCID']+"^"+session['LOGON.GROUPID'];
	   var pinNum="";
	   if(type=="Addexec"){
		   var date = $('#winRunOrderDate').datebox('getValue');
		   if (date==""){
			   $.messager.alert("提示","要求执行日期不能为空!","warning");
			   $('#winRunOrderDate').next('span').find('input').focus();
			   return false;
		   }
		   if(!ServerObj.DATE_FORMAT.test(date)){
			   $.messager.alert("提示","要求执行日期格式不正确!","warning");
			   return false;
		   }
		   var time=$('#winRunOrderTime').combobox('getValue');
		   if (time==""){
			   $.messager.alert("提示","要求执行时间不能为空!","warning");
			   $('#winRunOrderTime').next('span').find('input').focus();
			   return false;
		   }
		   if (!IsValidTime(time)){
			   $.messager.alert("提示","要求执行时间格式不正确! 时:分:秒,如11:05:01","warning");
			   return false;
		   }
	   }
	   var ReasonId="",Reasoncomment="";
	   ExpStr=ExpStr+"^"+ReasonId+"^"+Reasoncomment;
	   if ($("#winPinNum").length>0){
		   pinNum=$("#winPinNum").val();
		   if (pinNum==""){
			   $.messager.alert("提示","密码不能为空!","warning");
			   $("#winPinNum").focus();
			   return false;
		   }
	   }
	   
	   var SelOrdRowStr=GetSelOrdRowStr();
	   $.m({
		    ClassName:"web.DHCDocInPatPortalCommon",
		    MethodName:"MulOrdDealWithCom",
		    OrderItemStr:SelOrdRowStr,
		    date:date,
		    time:time,
		    type:type,
		    pinNum:pinNum,
		    ExpStr:ExpStr
		},function(val){
			if (val=="0"){
				if (type=="Addexec"){
					RefreshDataColGrid();
					appList_execObj.CureExecDataGridLoad();
				}
				com_Util.destroyDialog("CureOrdDiag");
			}else{
				$.messager.alert("提示",val,"warning");
				return false;
			}
		});
	}
	
	function IsValidTime(time){
		if (time.split(":").length==3){
		   var TIME_FORMAT=/^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/;
		}else if(time.split(":").length==2){
		   var TIME_FORMAT=/^(0\d{1}|1\d{1}|2[0-3]):([0-5]\d{1})$/;  
		}else{
		   return false;
		}
		if(!TIME_FORMAT.test(time)) return false;
		return true;
	}
	
	function FinishApplyClick(Type,DCARowId)
	{
		if(DCARowId==""){
			return;	
		}
		if(Type=="F"){var msg="请确认该申请治疗已完成,是否确认完成该申请?";}
		else{var msg="是否确认撤消完成该申请?"}
		$.messager.confirm('确认',msg,function(r){
			if (r){
				$.m({
					ClassName:"DHCDoc.DHCDocCure.Apply",
					MethodName:"FinishCureApply",
					'DCARowId':DCARowId,
					'UserID':session['LOGON.USERID'],
					'Type':Type
				},function testget(value){
					if(value == "0"){
						$.messager.show({title:"提示",msg:"确认成功"});
						RefreshDataColGrid();
					}else{
						if(value.indexOf("^")>0){
							var msg=value.split("^")[1];
						}else{
							var msg=value;	
						}
						$.messager.alert("提示","确认失败,"+msg,"warning");
					}				
					
				});
			}
		})
		
	}
	
	return{
		"AddOrderClick":AddOrderClick,
		"addExecOrderHandler":addExecOrderHandler,
		"addExecOrderShowHandler":addExecOrderShowHandler,
		"MulOrdDealWithCom":MulOrdDealWithCom,
		"FinishApplyClick":FinishApplyClick
	}
})()
var com_withLocDocFun=(function(){
	function InitComboLoc(locID,_docObj){
		var SessionStr=com_Util.GetSessionStr();
	    $.cm({
			ClassName:"DHCDoc.DHCDocCure.Config",
			QueryName:"FindLoc",
			SessionStr:SessionStr,
			dataType:"json",
			rows:99999
		},function(Data){
			$HUI.combobox("#"+locID, {
				valueField: 'LocRowID',
				textField: 'LocDesc', 
				editable:true,
				data: Data["rows"],
				filter: function(q, row){
					return (row["LocDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0)||(row["LocContactName"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
				},
				onSelect:function(record){
					if(typeof record=="undefined"){
						var locId="";
					}else{
						var locId=record.LocRowID;
					}
					if(_docObj){
						var url = $URL+"?ClassName=DHCDoc.DHCDocCure.Config&QueryName=QueryResource&LocID="+locId+"&ResultSetType=array";
						_docObj.clear();
						_docObj.reload(url);
					}
				}
			});
		});
	}
	function InitComboDoc(docID){
		var docObj=$HUI.combobox("#"+docID,{
			valueField:'TDocRowid',   
	    	textField:'TResDesc',
	    	filter: function(q, row){
				return (row["TResDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			}	
		})
		return docObj;
	}
	return{
		"InitComboLoc":InitComboLoc,
		"InitComboDoc":InitComboDoc
	}
})()