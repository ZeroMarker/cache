/**
* @author wujiang
*/
// var patNode={}
var treeTimer,dateformat,singleConfig=[],singleConfigObj,sixTimes=[],curEditorTarget,patientInfo,vsTableData=[];
var colIndex;//点击的列数0~5
var page=1, pageSize=10,confirmModal;
var inHospDTValue="", lastInHospDTValue="", transLocDTValue="";
var subScreen; // 副屏
// var frm = dhcsys_getmenuform();
// console.log(frm);
// if (frm) {
// 	patNode={
// 		episodeID:frm.EpisodeID.value,
// 		patientID:frm.PatientID.value
// 	}
// }
$.extend($.fn.datagrid.methods, {
	editCell: function(jq,param){
		return jq.each(function(){
			$(this).datagrid('endEdit', param.index);
			var opts = $(this).datagrid('options');
			var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor1 = col.editor;
				// if (fields[i] != param.field){
				if (param.field.indexOf(fields[i])<0){
					col.editor = null;
				}
			}
			$(this).datagrid('beginEdit', param.index);
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor = col.editor1;
			}
		});
	}
});
$(function() {
	if(EpisodeID) getPatInformation(EpisodeID,init);
	subScreen=window.parent.websys_emit && window.parent.websys_getMWScreens && window.parent.websys_getMWScreens().screens;
});
function getPatInformation(EpisodeID,callback) {
	InitPatInfoBanner(EpisodeID);
	if (callback) callback();
}
function init() {
	InitTip();
	// 获取日期格式
  var res=$cm({
    ClassName: 'Nur.NIS.Service.System.Config',
    MethodName: 'GetSystemConfig'
  }, false);
  patientInfo=$cm({
    ClassName: 'Nur.CommonInterface.Patient',
    MethodName: 'getPatient',
    episodeID: EpisodeID,
  }, false);
  dateformat=res.dateformat;
	$('#vsDate').datebox('setValue', ServerObj.CurrentDate);
	// $('#vsDate').datebox('setValue', "2021-04-26");
	var vsDateOpt=$("#vsDate").datebox('options');
	patientInfo.inHospDateTime=patientInfo.inHospDateTime?patientInfo.inHospDateTime.trim():'';
	patientInfo.regDateTime=patientInfo.regDateTime?patientInfo.regDateTime.trim():'';
	var inHospDay=(patientInfo.inHospDateTime||patientInfo.regDateTime).split(' ');
	inHospDTValue=new Date(standardizeDate(inHospDay[0])+' '+inHospDay[1]).valueOf();
	if (patientInfo.lastTimeInHosp) {
		var lastInHospDay=patientInfo.lastTimeInHosp.split(' ');
		lastInHospDTValue=new Date(standardizeDate(lastInHospDay[0])+' '+lastInHospDay[1]).valueOf();
	}else{
		lastInHospDTValue="";
	}
	if (patientInfo.latestTransLocDateTime) {
		var transLocDay=patientInfo.latestTransLocDateTime.split(' ');
		transLocDTValue=new Date(standardizeDate(transLocDay[0])+' '+transLocDay[1]).valueOf();
	}else{
		transLocDTValue="";
	}
	vsDateOpt.minDate = inHospDay[0];
	vsDateOpt.maxDate = ServerObj.CurrentDate;
	getSingleConfig();
	$('#nrLayout').layout('panel', 'west').panel({
	  onExpand: updateSvsTableSize,
	  onCollapse: updateSvsTableSize
  });
	// 模态框关闭后事件
	$("#vsddModal").dialog({
		onClose: function () {
			getTempDataByDay();
		}
	});
}
function getSingleConfig() {
  $cm({
    ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
    MethodName: 'GetAllTempConfig',
    locID: session['LOGON.CTLOCID'],
    time: "",
    wardId: session['LOGON.WARDID']
  }, function (data) {
  	singleConfig=data.SingleConfig;
		singleConfigObj={};
		for (var i = 0; i < singleConfig.length; i++) {
			var e=singleConfig[i];
			// singleConfig[i].desc=$g(e.yestDesc||e.desc);
			// 去除成人婴儿体征不匹配的项
			if (("N"==patientInfo.ifNewBaby)&&(1==e.flag)) {
				singleConfig.splice(i,1)
				i--;
				continue;
			}
			if (("Y"==patientInfo.ifNewBaby)&&('0'===e.flag)) {
				singleConfig.splice(i,1)
				i--;
				continue;
			}
			singleConfigObj[e.code]=e;
			if (e.code.indexOf('_Title')>-1) {
				singleConfig.splice(i,1)
				i--;
			}
		}
  	getTempDataByDay();
  });
}
function getInHospWeekday(day1,day2){
	day1 = Date.parse(standardizeDate(day1));
  day2 = Date.parse(standardizeDate(day2));
  var dateSpan = day2 - day1;
  dateSpan = Math.abs(dateSpan);
  var days = Math.floor(dateSpan / (24 * 3600 * 1000)) + 1;
  var week=Math.ceil(days/7);
  var day=(days%7)||7;
  return $g('第')+week+$g('周')+'/'+$g('第')+day+$g('天');
}
function preDay() {
	var curDay=$('#vsDate').datebox('getValue');
	var inHospDay=(patientInfo.inHospDateTime||patientInfo.regDateTime).split(' ')[0];
	if (curDay==inHospDay) {
    $.messager.popover({msg: $g('所选日期不能是入院前日期。'),type:'alert'});
    // 或大于病人出院日期
		return;
	}
	var newDay=Date.parse(standardizeDate(curDay))-24 * 3600 * 1000;
	$('#vsDate').datebox('setValue', formatDate(new Date(newDay)));
	getTempDataByDay();
}
function nextDay() {
	var curDay=$('#vsDate').datebox('getValue');
	if (curDay==ServerObj.CurrentDate) {
    $.messager.popover({msg: $g('所选日期不能是未来日期。'),type:'alert'});
    // 或大于病人出院日期
		return;
	}
	var newDay=Date.parse(standardizeDate(curDay))+24 * 3600 * 1000;
	$('#vsDate').datebox('setValue', formatDate(new Date(newDay)));
	getTempDataByDay();
}
function getTempDataByDay(){
	$(".tooltip").hide();
	var count=0;
	var curDay=$('#vsDate').datebox('getValue');
	var newDay=Date.parse(standardizeDate(curDay))-24 * 3600 * 1000;
	var preDay=formatDate(new Date(newDay));
  var preRes,res;
  $cm({
    ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
    MethodName: 'GetTempDataByDayEncode',
    episodeID: EpisodeID,
    date: preDay
  }, function (data) {
		preRes=data;
		count++;
  });
  $cm({
    ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
    MethodName: 'GetTempDataByDayEncode',
    episodeID: EpisodeID,
    date: curDay
  }, function (data) {
		res=data;
		count++;
		if (subScreen) {
			var t=window.parent.websys_emit("onOpenTempPreview",{EpisodeID:EpisodeID,MWToken:websys_getMWToken(),Date:curDay});
			console.log(t);
		}
  });
	var timer=setInterval(function() {
		if (count>1) {
			clearInterval(timer);
			curDay=standardizeDate(curDay);
			var inHospDay=(patientInfo.inHospDateTime||patientInfo.regDateTime).split(' ')[0];
			var columns=[
				[
					{title:getInHospWeekday(inHospDay,$('#vsDate').datebox('getValue')), align:'left',halign:'left'},
					{title:$g('上午'), align:'center',halign:'center',colspan:3},
					{title:$g('下午'), align:'center',halign:'center',colspan:3}
				],[
					{title:'时间	',field:'vsItem', align:'left',width:200,styler: function (value, row, index) {
							if (row.titleFlag) return 'background: #e4e4e4!important;';
							if (row.blank) {
								var dateValue=new Date(curDay+' '+"23:00").valueOf();
								// 校验入院时间
								if (inHospDTValue>dateValue) return 'background: #e4e4e4!important;';
								if (lastInHospDTValue&&(lastInHospDTValue<dateValue)) return 'background: #e4e4e4!important;';
								// 校验转科时间
								if ((!modify)&&transLocDTValue&&(transLocDTValue>dateValue)) return 'background: #e4e4e4!important;';
							}
						}
					}
				]
			];
			var timesFlag=true,data=[];
			for (var i = 0; i < singleConfig.length; i++) {
				var sc=singleConfig[i]
				var times=sc.times;
				if (timesFlag) {
					if (6==times.length) {
						sixTimes=times;
						timesFlag=false;
						times.map(function(e,i) {
							columns[1].push(
								{title:e+$g('点'),field:'point'+e, align:'center',width:100,styler: function (value, row, index) {
									if ((("undefined" == typeof value)||(""===value))&&row.fControl) {
										if (row.fControl.values.length>=row.times.length) {
											return { class: "fControl" };
										}
									}
									if (row.normalValueRangFrom || row.normalValueRangTo) {
										if (value==parseFloat(value)) {
											if (value < row.normalValueRangFrom || value > row.normalValueRangTo) {
												// return 'color: rgb(246, 164, 5);border: 2px solid rgb(246, 164, 5)!important;';
												return {class:"warning"};
											}
										}
									}
									if (row.times.length==1) {
										// 校验转科时间
										var afternoon=new Date(curDay+' '+timePoint[3]).valueOf();
										if ((!modify)&&transLocDTValue) {
											if (transLocDTValue>afternoon) return 'background: #e4e4e4!important;';
										}
										if (inHospDTValue>afternoon) return 'background: #e4e4e4!important;';
										if (lastInHospDTValue&&(lastInHospDTValue<afternoon)) return 'background: #e4e4e4!important;';
									}
									if (row.times.length==2) {
										var morning=new Date(curDay+' '+timePoint[1]).valueOf();
										var afternoon=new Date(curDay+' '+timePoint[3]).valueOf();
										if (i<3) {
											if (inHospDTValue>morning) return 'background: #e4e4e4!important;';
											if (lastInHospDTValue&&(lastInHospDTValue<morning)) return 'background: #e4e4e4!important;';
										} else {
											if (inHospDTValue>afternoon) return 'background: #e4e4e4!important;';
											if (lastInHospDTValue&&(lastInHospDTValue<afternoon)) return 'background: #e4e4e4!important;';
										}
										
										var midDayValue=new Date(curDay+' '+"12:00").valueOf();
										// 校验入院时间（早上入院可录2次，下午入院可录1次）
										if ((inHospDTValue>=midDayValue)&&(i<3)) return 'background: #e4e4e4!important;';
										// 校验转科时间
										if ((!modify)&&transLocDTValue) {
											var afternoon=new Date(curDay+' '+timePoint[3]).valueOf();
											if (transLocDTValue>afternoon) return 'background: #e4e4e4!important;';
											var morning=new Date(curDay+' '+timePoint[1]).valueOf();
											if ((transLocDTValue>morning)&&(i<3)) return 'background: #e4e4e4!important;';
										}
									}
									if (row.times.length==6) {
										var dateValue=new Date(curDay+' '+timePoint[i]).valueOf();
										// 校验入院时间
										if (inHospDTValue>dateValue) {
											var midDayValue=new Date(curDay+' '+"12:00").valueOf();
											if (inHospDTValue>midDayValue) {
												if (i<5) return 'background: #e4e4e4!important;';
											} else {
												if (i<2) return 'background: #e4e4e4!important;';
											}
										}
										// 校验出院时间
										if (lastInHospDTValue&&(lastInHospDTValue<dateValue)) return 'background: #e4e4e4!important;';
										// 校验转科时间
										if ((!modify)&&transLocDTValue&&(transLocDTValue>dateValue)) return 'background: #e4e4e4!important;';
									}
										// var dateValue=new Date(curDay+' '+timePoint[i]).valueOf();
										// // 校验入院时间
										// if (inHospDTValue>dateValue) return 'background: #e4e4e4!important;';
										// // 校验转科时间
										// if ((!modify)&&transLocDTValue&&(transLocDTValue>dateValue)) return 'background: #e4e4e4!important;';
								}}
							);
						})
					}
				}
				var code=sc.code;
				if (code.indexOf('_Title')>-1) continue;
				var validate=JSON.parse(sc.validate);
				var item={
					code:code,
					times:times,
					vsItem:sc.yestDesc||sc.desc,
					yestDesc:sc.yestDesc,
					udFlag:sc.udFlag,
					options:sc.options,
					symbol:sc.symbol,
					blank:JSON.parse(sc.blank),
					select:JSON.parse(sc.select),
					validate:validate,
					colspan:6/times.length
				};
				if (item.blank) {
					item.blankTitleCode=sc.blankTitleCode;
					item.blankTitleInputTime=sc.blankTitleInputTime;
					if (sc.yestDesc) {
						var value=preRes[sc.blankTitleCode][sc.blankTitleInputTime].value;
					} else {
						var value=res[sc.blankTitleCode][sc.blankTitleInputTime].value;
					}
					if (value) {
						item.vsItem=value;
						item.titleFlag=true;
					} else {
						item.vsItem=singleConfigObj[sc.blankTitleCode].desc;
					}
				}
				if (validate) {
					if (sc.normalValueRangFrom) item.normalValueRangFrom=parseFloat(sc.normalValueRangFrom);
					if (sc.normalValueRangTo) item.normalValueRangTo=parseFloat(sc.normalValueRangTo);
					if (sc.errorValueHightFrom) item.errorValueHightFrom=parseFloat(sc.errorValueHightFrom);
					if (sc.errorValueLowTo) item.errorValueLowTo=parseFloat(sc.errorValueLowTo);
				}
				times.map(function(e,i) {
					if (sc.yestDesc) {
						item['point'+sixTimes[i*item.colspan]]=res[code][e]?preRes[code][e].value:'';
						if (preRes.fControl[code]) {
							item.fControl=preRes.fControl[code];
						}
					} else {
						item['point'+sixTimes[i*item.colspan]]=res[code][e]?res[code][e].value:'';
						if (res.fControl[code]) {
							item.fControl=res.fControl[code];
						}
					}
				});
				data.push(item);
			}
			vsTableData=data;
			$('#singleVSTable').datagrid({
				title:$g('体征采集'),
				// height:'600',
				// style:'width:98%;background:red;',
				singleSelect:true,
				toolbar: '#toolbar',
				headerCls:'panel-header-gray',
				iconCls:'icon-target-arrow',
				autoSizeColumn:false,
				fitColumns:true,
				pagination:false,
				columns:columns,
				data:vsTableData,
				onClickCell:function(index, field, value) {
					console.log(index, field, value);
					var rows=$('#singleVSTable').datagrid('getRows')
					if ("vsItem"==field) {
						if (!rows[index].blank) return;
						var bgColor=$('tr[datagrid-row-index="'+index+'"]>td[field="vsItem"]').css('backgroundColor');
						if ('rgb(228, 228, 228)'==bgColor) return;
					}
					colIndex=sixTimes.indexOf(parseInt(field.slice(5)));
					editTableCell(index, field);
				},
				onDblClickCell:function(index, field, value) {
					var rows=$('#singleVSTable').datagrid('getRows')
					if ("vsItem"==field) {
						if (!rows[index].blank) return;
						var $blankTitle=$('tr[datagrid-row-index="'+index+'"]>td[field="vsItem"]');
						var bgColor=$blankTitle.css('backgroundColor');
						if ('rgb(228, 228, 228)'==bgColor) {
							if (lastInHospDTValue&&(lastInHospDTValue<new Date($('#vsDate').datebox('getValue')).valueOf())) return $.messager.popover({msg: $g('出院后的数据不能被更改。'),type:'alert'});
							$blankTitle.css('backgroundColor','transparent!important');
							$blankTitle.css('background','transparent');
							$.messager.popover({msg: $g('如若更改该空白栏标题，则本住院周的数据都将被更改。'),type:'info'});
						}
					}
				},
				onAfterEdit:function(index,data,changes){
					var rows=$('#singleVSTable').datagrid('getRows')
					margeTableCell(rows);
				},
				onLoadSuccess:function(data){
					margeTableCell(data.rows);
					showFControlTip();
					updateSvsTableSize();
				}
			});
		}
	});
}
function showFControlTip(){
	var $td = $(".vsContent td.fControl");
	$td.mouseenter(function (event) {
		var index = $(this).parent().attr("datagrid-row-index");
		var row=vsTableData[index].fControl;
		var content = "体征项已录入，不允许多次录入！<br>";
		content += "操作时间：" + row.opeTimes.join('/') + "<br>";
		content += "数据时间：" + row.dataTimes.join('/') + "<br>";
		content += "数值：" + row.values.join('/') + "<br>";
		content += "操作用户：" + row.users.join('/') ;
		var placement = "bottom";
		if (index > 8) placement = "top";
		$(this).popover({
			trigger: "manual",
			placement: placement,
			content: content,
		}).popover("show");
	}).mouseleave(function () {
		if ($(this) && $(this).popover) {
			try {
				$(this).popover("hide");
			} catch (e) {}
		}
	});
}
function endEditTableCell(flag){
	if (1==flag) {
		$(".tooltip").hide();
	}
	var rows=$('#singleVSTable').datagrid('getRows');
	// 结束编辑
	for (var i = 0, len = rows.length; i < len; i++) {
		e=rows[i];
		var ed = $('#singleVSTable').datagrid("getEditors",i)[0];// 获取编辑器
		if (ed) {
			console.log(ed);
			if ("vsItem"==ed.field) {
				console.log(123);
				e=singleConfigObj[e.blankTitleCode];
		  	e.select=JSON.parse(e.select);
				var time=rows[i].blankTitleInputTime;
			} else {
				var time=ed.field.slice(5);
				time=e.times[sixTimes.indexOf(parseInt(time))/e.colspan];
			}
			if (e.select) {
				var value=$(ed.target).combobox('getValue');
				console.log(value);
				if ((''===value)&&("Y"==e.udFlag)) {
					value=$(ed.target).combobox('textbox').val();
					$(ed.target).combobox("setValue",value);
				}
			} else {
				var value=$(ed.target).val();
			}
			$(ed.target).removeClass('error');
			if (e.validate&&(''!==value)) {
				var symbol = e.symbol;
        if (!symbol || (symbol.indexOf(value)<0)) {
        	if (e.errorValueHightFrom || e.errorValueLowTo) {
        		if (value!=parseFloat(value)) {
	            $.messager.popover({msg: $g('请填写正确的数值！'),type:'alert'});
	            return false;
	          // } else if (value.length!=(parseFloat(value)).toString().length) { // 需求号：2627879
	          //   $.messager.popover({msg: $g('数值小数点后为0不能保存！'),type:'alert'});
	          //   return false;
	          } else {
							value=parseFloat(value);
						}
	          if (value > e.errorValueHightFrom || value < e.errorValueLowTo) {
							$(ed.target).addClass('error');
	            $.messager.popover({msg: $g('填写的值超出正确范围！'),type:'alert'});
	            return false;
	          }
        	}
        }
			}
			var eTitle=singleConfigObj[e.code+"_Title"];
			if (eTitle&&(''!==value)&&(e.vsItem==eTitle.desc)) {
				$.messager.popover({msg: $g('录入空白栏数据前请先录入空白栏标题！'),type:'alert'});
				return false;
			}
      var vsDate = $('#vsDate').datebox('getValue');
			if (e.yestDesc||(eTitle&&eTitle.yestDesc)) {
				var newDay=Date.parse(standardizeDate(vsDate))-24 * 3600 * 1000;
				vsDate=formatDate(new Date(newDay));
			}
			if (singleConfigObj[e.code].formulaControl=="Y") {
				checkFormulaControl(vsTableData[i]['point'+time],value,i,'point'+ed.field.slice(5))
			}
	    var res=$cm({
			ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
			MethodName: "SaveObsDataByDay",
			dataType: "text",
			episodeID:EpisodeID,
			modifyData:JSON.stringify([{
				code:e.code,
				value:value,
				time:time
			}]),
			userID:session["LOGON.USERID"],
			date:vsDate,
			userLocID:session["LOGON.CTLOCID"],
			wardID:session['LOGON.WARDID']
	    }, false);
		if ('-1000'==res) {
			$('#singleVSTable').datagrid('endEdit', i);
			applyAuthority();
		} else if (0==parseInt(res)) {
			if (res.toString().indexOf('^')>-1) {
				$.messager.popover({msg: $g(res.split('^')[1]),type:'alert'});
			}else if (1==flag) {
				$.messager.popover({msg: $g('数据保存成功'),type:'success'});
			}
		if(subScreen) {
			window.parent.websys_emit("vitalSignChange",{});
		}
			var $td=$("td>input.datagrid-editable-input").parent();
			if (!$td.length) $td=$("td[field^=point]");
			var width=$td.width(),height=$td.height();
			width=Math.floor(width);
			height=Math.ceil(height-1);
			$("style.datagridCell").html('td.warning>div{color: rgb(246, 164, 5);border: 2px solid rgb(246, 164, 5)!important;box-sizing: border-box;width: calc(100% - 0px);height: '+height+'px!important;line-height: '+(height-4)+'px;}')
			if (e.code.indexOf('_Title')>-1) {
				vsTableData.map(function (vd,ind) {
					if (e.code==vd.blankTitleCode) {
						vsTableData[ind].titleFlag=(''===value)?false:true;
					}
				})
			}
      } else {
        $.messager.popover({msg: res,type:'alert'});
				return false;
      }
      if (2!=flag) {
				$('#singleVSTable').datagrid('endEdit', i);
				// $('#singleVSTable').datagrid('loadData', {rows:vsTableData});
      }
			// 更新控制体征项录入频次的数据
			if (singleConfigObj[e.code].formulaControl=="Y") {
				updateFormulaControlData(i,vsDate,e.code);
			}
			return true;
		}
	}
	return true;
}
function applyAuthority() {
	if (confirmModal&&!$(confirmModal).parent().is(":hidden")) return;
    var oldOk = $.messager.defaults.ok;
    var oldNo = $.messager.defaults.no;
    $.messager.defaults.ok = $g("申请授权");
    $.messager.defaults.no = $g("取消");
    confirmModal = $.messager.confirm($g("提示"), $g("病人已出院，限制操作，请申请出院病历授权"), function (r) {
        if (true===r) {
			var url='nur.emr.dischargerecordauthorizeapply.csp?mouldType=SMTZ&regNo='+patientInfo.regNo; 
			if ("undefined" != typeof websys_getMWToken) {
			  url += "&MWToken=" + websys_getMWToken();
			}
			window.location.href=url;
        }
        /*要写在回调方法内,否则在旧版下可能不能回调方法*/
        $.messager.defaults.ok = oldOk;
        $.messager.defaults.no = oldNo;
    })
	var btns =confirmModal.children("div.messager-button");
    btns.children("a.l-btn").css({width:'auto'});
    $(".window-shadow").map(function (i,obj) {
        $(obj).css({height:$(obj).prev().height()});
    });
}
function checkFormulaControl(oldVal,newVal,i,field) {
	var row=vsTableData[i];
	var len=row.fControl.values.length;
	if ((''===oldVal)&&(''!==newVal)) { // 添加数据
		if ((len+1)>=row.times.length) {
			sixTimes.map(function (st) {
				var newField='point'+st;
				if ((''===row[newField])&&(field!=newField)) {
					$('tr[datagrid-row-index="'+i+'"] td[field="'+newField+'"]').addClass('fControl');
				}
			})
			vsTableData[i].fControl.values.length=len+1;
		}
	}
	if ((''!==oldVal)&&(''===newVal)) { // 删除数据
		if ((len-1)<row.times.length) {
			sixTimes.map(function (st) {
				var newField='point'+st;
				if ((''===row[newField])&&(field!=newField)) {
					$('tr[datagrid-row-index="'+i+'"] td[field="'+newField+'"]').removeClass('fControl');
				}
			})
			vsTableData[i].fControl.values.length=len-1;
		}
	}
}
function updateFormulaControlData(i, date, item) {
	var res = $cm(
		{
			ClassName: "Nur.NIS.Service.VitalSign.Temperature",
			MethodName: "GetFormulaControlData",
			episodeID: EpisodeID,
			date: date,
			item: item,
			userLocID: session["LOGON.CTLOCID"],
		},
		false
	);
	vsTableData[i].fControl=res[item];
	showFControlTip();
}
function editTableCell(index, field, keyCode){
	var saveRes=endEditTableCell();
	if (!saveRes) return;
	var $td=$('tr[datagrid-row-index="'+index+'"]>td[field="'+field+'"]');
	var bgColor=$td.css('backgroundColor');
	console.log(bgColor);
	if ('rgb(228, 228, 228)'==bgColor) {
		if (keyCode) {
			forwardTableCell(index, field, keyCode);
		}
		return;
	}
	var rows=$('#singleVSTable').datagrid('getRows'),row=rows[index];
	if ("vsItem"==field) {
		row=singleConfigObj[row.blankTitleCode];
		row.times=[rows[index].blankTitleInputTime];
  	row.select=JSON.parse(row.select);
	}
	var tipId=row.code+"Tip";
	if (row.symbol&&!$("#"+tipId).length) {
		var tipDom='<div id="'+tipId+'">';
		row.symbol.map(function(e) {
			tipDom+='<a href="#" name="symbol" class="easyui-linkbutton" data-options="plain:true" data-text="'+e+'"></a>';
		})
		tipDom+='</div>';
		$("#toolTips").append(tipDom);
		$("a[name='symbol']").map(function(index,elem) {
			var text=$(this).data('text');
      $(elem).linkbutton({size:'small',onClick:function () {addSymbol(text);},text:text});
		});
	}
	var e = $('#singleVSTable').datagrid('getColumnOption', field);
	if (row.select) {
		var optData=[];
		row.options.map(function(item) {
			optData.push({item:item})
		})
		e.editor = {
	    type:'combobox',
	    options:{
				valueField:'item',
				textField:'item',
				data:optData,
				defaultFilter:6,
	    }
	  };
	} else {
		e.editor = {
	    type:'text',
	    options:{
	      required:true
	    }
	  };
	}
	$('#singleVSTable').datagrid('editCell', {
		index:index,
		field:[field]||[]
	});
	var ed = $('#singleVSTable').datagrid("getEditor", {index: index, field: field});// 获取编辑器
	curEditorTarget=ed.target;
	if (("vsItem"==field)&&!vsTableData[index].titleFlag) {
		$(ed.target).combobox('setValue','')
	}
	$(ed.target).focus().bind('keyup',function(e) {
		if ("vsItem"==field) {
			// if (13==e.keyCode) endEditTableCell();
			return;
		}
		if (13==e.keyCode) e.keyCode=40;
		if ([13,37,38,39,40].indexOf(e.keyCode)>-1) {
			forwardTableCell(index, field, e.keyCode);
			return;
		}
	}).bind('blur', function(e) {
		blurTimer=setTimeout(function() {
			endEditTableCell(2);
		}, 300);
	});
	if (row.select) {
		$(ed.target).combobox('textbox').bind('focus',function(){
      $(ed.target).combobox('showPanel')
      $(ed.target).combobox('textbox').bind("keyup",function(e) {
				if ("vsItem"==field) {
					// $(this).bind("change",endEditTableCell);
					return;
				}
      	if (13==e.keyCode) {
      		keyCode=keyCode || 40;
					if ([13,37,38,39,40].indexOf(keyCode)>-1) {
						forwardTableCell(index, field, keyCode);
						return;
					}
      	}
      })
    }).focus();
	};
	$(".tooltip").hide();
	if (row.symbol) {
		$(ed.target).tooltip({
	    position: 'top',
	    hideEvent: 'none',
	    showDelay: 0,
	    deltaY: 10,
	    backgroundColor: "rgba(255,255,255,0.8)",
	    content: function(){
				return $('#'+tipId);
			},
	    onShow: function(e){
				$(this).tooltip('tip').css({
					left: e.clientX-e.offsetX-($('#'+tipId).width()+18-e.target.clientWidth)/2+'px',
					top: e.clientY-e.offsetY-35+'px',
					background: '#fff',
					border: '1px solid #cccccc',
				});
	    }
		});
		$HUI.tooltip(ed.target).show();
		$(curEditorTarget).tooltip("tip").css({
			background: '#fff',
			border: '1px solid #cccccc',
		});
	}
}
function forwardTableCell(index, field, keyCode){
	var rows=$('#singleVSTable').datagrid('getRows'),row=rows[index];
	var colspan;
	switch(keyCode){
	  case 38: //上
			if (0==index) {
				index=rows.length-1;
				if (0==colIndex) {
					colIndex=5;
				} else {
					colIndex--;
				}
			} else {
				index--;
			}
			break;
	  case 40: //下
			if (index==(rows.length-1)) {
				index=0;
				if (5==colIndex) {
					colIndex=0;
				} else {
					colIndex++;
				}
			} else {
				index++;
			}
			break;
	  case 37: //左
			if (0==colIndex) {
				if (0==index) {
					index=rows.length-1;
				} else {
					index--;
				}
				colspan=rows[index].colspan;
				colIndex=6-colspan;
			} else {
				colspan=rows[index].colspan;
				colIndex-=colspan;
			}
			break;
	  case 39: //右
			colspan=rows[index].colspan;
			if ((colIndex+colspan)>5) {
				colIndex=0;
				if (index==(rows.length-1)) {
					index=0;
				} else {
					index++;
				}
			} else {
				colIndex+=colspan;
			}
			break;
	  default:
			return;
	}
	colspan=rows[index].colspan;
	field='point'+sixTimes[Math.floor(colIndex/colspan)*colspan];
	editTableCell(index, field, keyCode)
}
function addSymbol(d){
	console.log(d);
	$(curEditorTarget).val($(curEditorTarget).val()+d)
}
function margeTableCell(rows){
	rows.map(function(e,i) {
		if (e.times.length<6) {
			e.times.map(function(e1,i1) {
				$('#singleVSTable').datagrid('mergeCells',{
					index: i,
					field: 'point'+sixTimes[i1*e.colspan],
					colspan: e.colspan
				});
			})
		}
	})
}
function InitTip(){
	var _content="<p>"+$g("红色框：")+$g("非有效数据")+"</p>";
	_content+="<p>"+$g("黄色框：")+$g("非正常数据")+"</p>";
	$("#vsReminder_tip").popover({
		trigger:'hover',
		content:_content,
		style:'inverse'
	});
}
function preShow() {
  var url = "nur.hisui.temperature.linux.csp"+"?EpisodeID="+EpisodeID;
  if ("undefined" != typeof websys_getMWToken) {
    url += "&MWToken=" + websys_getMWToken();
  }
  // http://192.168.1.108/imedical/web/csp/nur.hisui.temperature.linux.csp?EpisodeID=112
  var width, height, left, top;
  if (window.screen.availWidth > 1900) {
    width = Math.floor(window.screen.availWidth * 0.79);
    height = Math.floor(window.screen.availHeight * 0.83);
    left = (window.screen.availWidth - width) / 2;
    top = (window.screen.availHeight - height) / 3;
  } else {
    width = Math.floor(window.screen.availWidth * 0.98);
    height = Math.floor(window.screen.availHeight * 0.83);
    left = (window.screen.availWidth - width) / 3;
    top = (window.screen.availHeight - height) / 3;
  }
  window.open(
    url,
    "newwindow",
    "width=" +
    width +
    ",height=" +
    height +
    ",top=" +
    top +
    ",left=" +
    left +
    ",toolbar=no,menubar=yes,scrollbars=yes,resizable=yes,location=no,status=no"
  );
}
// 标准化日期
function standardizeDate(day) {
	var y=dateformat.indexOf('YYYY');
	var m=dateformat.indexOf('MM');
	var d=dateformat.indexOf('DD');
	var str=day.slice(y,y+4)+'/'+day.slice(m,m+2)+'/'+day.slice(d,d+2);
	return str;
}
function updateHeight(id) {
	// console.log($('#editContent'));
	var $ec=$('#'+id)[0];
	if ($ec.offsetHeight<$ec.scrollHeight) {
		$('#'+id).height(Math.max(60,$ec.scrollHeight));
	} else {
		if ($ec.offsetHeight<=65) return;
		var timer = setInterval(function(){
			$('#'+id).height($ec.offsetHeight-28);
			if($ec.offsetHeight<$ec.scrollHeight) {
				clearInterval(timer);
				$('#'+id).height(Math.max(60,$ec.scrollHeight));
			}
		},50);
	}
}
// 更新模态框位置
function updateModalPos(id) {
  var offsetLeft=(window.innerWidth-$('#'+id).parent().width())/2;
  var offsetTop=(window.innerHeight-$('#'+id).parent().height())/2;
  $('#'+id).dialog({
    left: offsetLeft,
    top: offsetTop
  }).dialog("open");
}
function setDateboxOption() {
	// var startDate=$("#startDate").datebox('getValue'),stopDate=$("#stopDate").datebox('getValue');
	// var startOpt=$("#startDate").datebox('options'),stopOpt=$("#stopDate").datebox('options');
	// if (startDate) stopOpt.minDate = startDate;
	// if (stopDate) startOpt.maxDate = stopDate;
}
function updateSvsTableSize() {
	var n=0;
	var timer = setInterval(function(){
		var innerHeight=window.innerHeight;
		if ($('#singleVSTable').datagrid) {
			console.log($("#patFrame").width());
			$('#singleVSTable').datagrid('resize',{
				width:$("#patFrame").width(),
			  height:innerHeight-49
			})
		}
		n++;
		if(n>6) {
			clearInterval(timer);
			var $td=$("td.warning");
			if ($td.length<1) return;
			var width=$td.width(),height=$td.height();
			// width=Math.ceil(width-1);
			width=Math.floor(width);
			height=Math.ceil(height-1);
			// $("style.datagridCell").html('td.warning>div{color: rgb(246, 164, 5);border: 2px solid rgb(246, 164, 5)!important;box-sizing: border-box;width: '+width+'px;height: '+height+'px!important;line-height: '+(height-4)+'px;}')
			$("style.datagridCell").html('td.warning>div{color: rgb(246, 164, 5);border: 2px solid rgb(246, 164, 5)!important;box-sizing: border-box;width: calc(100% - 0px);height: '+height+'px!important;line-height: '+(height-4)+'px;}')
		}
	},200);
}
window.addEventListener("resize",updateSvsTableSize);
