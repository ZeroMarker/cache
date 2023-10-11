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
var editBGCell=(function() {
	var oldFields;
	return function(fields,index) {
		if (fields) oldFields=fields;
		$('#multiVSTable').datagrid('editCell', {
			index:index,
			field:oldFields||[]
		});
	};
})();
var enterkeyCode=localStorage.getItem("enterkeyCode"+session['LOGON.USERID']);
if ('undefined'==typeof HISUIStyleCode) {
	var HISUIStyleCode="blue";
}
if (!enterkeyCode) {
	enterkeyCode=39; // Enter键方向，默认向右
}
enterkeyCode=parseInt(enterkeyCode);
var patNode,saveFlag=true,dateformat,singleConfigObj,singleConfig=[],multiColumns=[],colCodes=[],colCodesObj = {},colCodesArr = [],curEditorTarget,patientList=[],patientObj={},qcPageSize=20,secondScreen={};
var timeouter,vitalsignData,colIndex,originColIndex,confirmModal;
var frm = dhcsys_getmenuform();
var timeArr=["02:00", "06:00", "10:00", "14:00", "18:00", "22:00"];
var bedWidth=50,nameWidth=125,ageWidth=70,careWidth=76,normalWidth=125,abbrWidth=60; // 设置列宽
var subScreen; // 副屏
$('#multiVSTable').datagrid({
	singleSelect: true,
	onClickRow: function (rowIndex, rowData) {
		$(this).datagrid('unselectRow', rowIndex);
	},
});
$(function() {
	// $("body").append('<style>#multiVSPanel .datagrid-view2 td.warning>div{width: '+(normalWidth-19)+'px;}</style>')
	// $("body").append('<style>#multiVSPanel .datagrid-view2 td.warning.abbrItem>div{width: '+(abbrWidth-19)+'px;}</style>')
	if ('lite'==HISUIStyleCode) { //极简
		if (IsPopUp) { //极简弹窗
			$('.eduExeStyle').append('.layout-split-west {border-right: 5px solid #ffffff;}');
		} else {
			$('.eduExeStyle').append('body{background: #f5f5f5!important;}');
		}
		$('#multiSaveBtn').css('top','1px').addClass('green');
	}
	init();
	if (frm) {
		patNode={
			episodeID:frm.EpisodeID.value,
			patientID:frm.PatientID.value
		}
		console.log(patNode);
	} else {
		$('#multiVSTable').datagrid({
			data:{total:0,rows:[]}
		});
		updateDomSize();
	}
	// 模态框关闭后事件
	$("#singleVSModal").dialog({
		onClose: toggleSwitch
	});
	$("#vsddModal").dialog({
		onClose: toggleSwitch
	});
	$('#enterDirect').combobox('setValue',enterkeyCode);
	subScreen=window.parent.websys_emit && window.parent.websys_getMWScreens && window.parent.websys_getMWScreens().screens;
});
/**
* @description 展示病人标题信息
* @param {EpisodeID} 患者就诊号
*/
function setPatientInfo(EpisodeID) {
	$m({
		ClassName: "web.DHCDoc.OP.AjaxInterface",
		MethodName: "GetOPInfoBar",
		CONTEXT: "",
		EpisodeID: EpisodeID
	}, function(html) {
		if (html != "") {
			$(".PatInfoItem").html(reservedToHtml(html));
		} else {
			$(".PatInfoItem").html($g("获取病人信息失败。请检查【患者信息展示】配置。"));
		}
	});
	function reservedToHtml(str) {
		var replacements = {
			"&lt;": "<",
			"&#60;": "<",
			"&gt;": ">",
			"&#62;": ">",
			"&quot;": "\"",
			"&#34;": "\"",
			"&apos;": "'",
			"&#39;": "'",
			"&amp;": "&",
			"&#38;": "&"
		};
		return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g, function(v) {
			return replacements[v];
		});
	}
}
// 初始化
function init() {
	InitTip();
	// 获取日期格式
	var res=$cm({
		ClassName: 'Nur.NIS.Service.System.Config',
		MethodName: 'GetSystemConfig'
	}, false);
	dateformat=res.dateformat;
	$('#endDate').datebox('setValue', formatDate(new Date()));
	$('#currentDay').datebox('setValue', formatDate(new Date()));
	if (0==vsGenelConfig.QC) {
		$("#qcBtn").parent().hide();
	}
	var endPoint=vsGenelConfig.endPoint.split(',');
	var timePoint=vsGenelConfig.timePoint.split(',');
	timeArr=timePoint;
	var curTime=new Date().toString().split(' ')[4].slice(0,5);
	for (var i = 0; i < endPoint.length; i++) {
		if (curTime<endPoint[i]) {
			$("#timePoint").timespinner('setValue', timePoint[i]);
			$("#timePoint").parent().parent().hide();
			break;
		}
	}
	for (var i = 0; i < timePoint.length; i++) {
		$("#timePointBtns table tr>td:eq("+i+")>a").attr('data-time', timePoint[i]).find('.l-btn-text').html(parseInt(timePoint[i]));
	}
	setDateboxOption();
  	getSingleConfig();
}
// 获取某些天的血糖记录
function setTimeVal(obj) {
	$("#timePoint").timespinner('setValue', $(obj).data('time'));
	// getPatientsTempDataByTime();
}
// 获取某些天的血糖记录
function toggleSwitch(e, d) {
	$(".tooltip.tooltip-top").hide();
	if ($("#switch").switchbox('getValue')) { // 多时间点
		$("#timePoint").parent().parent().hide();
		$("#timePointBtns").hide();
		getPatientsTempDataByDay();
	} else { // 单时间点
		$("#timePoint").parent().parent().show();
		$("#timePointBtns").show();
		getPatientsTempDataByTime();
	}
}
function vsItemChange(e,v) {
	if (v) {
  	singleConfig.map(function(e) {
  		v=v && $("#"+e.code).checkbox('getValue');
  	})
	}
	if (saveFlag) {
		if ($("#switch").switchbox('getValue')) {
			getPatientsTempDataByDay();
		} else {
			getPatientsTempDataByTime();
		}
	}
	saveFlag=false;
	$("#checkAll").checkbox('setValue',v);
	timeouter=setTimeout(function(){
		saveFlag=true;
	},50);
}
function checkAllBG(e,v) {
	if (saveFlag) {
		saveFlag=false
		singleConfig.map(function(e) {
			$("#"+e.code).checkbox('setValue',v);
		})
		timeouter=setTimeout(function(){
			saveFlag=true;
		},300);
		if ($("#switch").switchbox('getValue')) {
			getPatientsTempDataByDay();
		} else {
			getPatientsTempDataByTime();
		}
	}
}
function findMultiTempData(e,v) {
	console.log(arguments);
}
function getPatientsByEpisodeIDs(){
	if ($("#switch").switchbox('getValue')) {
		getPatientsTempDataByDay();
	} else {
		getPatientsTempDataByTime();
	}
}
function getPatientsTempDataByDay(){
	var count=0;
	// 获取患者信息
	var nodes=$('#mvsLayout #patientTree').tree('getChecked'),episodeIDs=[];
	for (var i = 0; i < nodes.length; i++) {
		if ((nodes[i].episodeID)&&($(nodes[i].target).css('display')!="none")) {
			episodeIDs.push(nodes[i].episodeID);
		} else {
			nodes.splice(i,1);
			i--;
		}
	}
	$cm({
		ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
		MethodName: 'GetPatientsByEpisodeIDs',
		EpisodeIDs: episodeIDs.join('^')
	}, function(res) {
		patientList=res;
		res.map(function (r) {
			patientObj[r.episodeID]={
				name:r.name,
				bedCode:r.bedCode,
			}
		})
		count++;
  	});
	var curDay=$('#currentDay').datebox('getValue');
	var newDay=Date.parse(standardizeDate(curDay))-24 * 3600 * 1000;
	var preDay=formatDate(new Date(newDay));
	var needMeasure=$("#needMeasure").checkbox('getValue')?1:'';
	var preRes={},res={};
	if (episodeIDs.length) {
		$cm({
			ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
			MethodName: 'GetTempDateMeasureByDayEncode',
			episodeIDS: episodeIDs.join('^'),
			date: preDay,
			locID: session['LOGON.CTLOCID'],
			needMeasure: needMeasure,
		}, function (data) {
			preRes=data;
			var keys=Object.keys(data);
			if (keys.length&&keys[0].length>6) abbrWidth=73;
			count++;
		});
		$cm({
			ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
			MethodName: 'GetTempDateMeasureByDayEncode',
			episodeIDS: episodeIDs.join('^'),
			date: curDay,
			locID: session['LOGON.CTLOCID'],
			needMeasure: needMeasure,
		}, function (data) {
			res=data;
			count++;
		});
	} else {
		count=count+2;
	}
	var timer=setInterval(function() {
		if (count>2) {
			clearInterval(timer);
			if (res.fControl) {
				patientList.map(function (p,i) {
					patientList[i].fControl={}
					if(!res.fControl||!res.fControl[p.episodeID]) return;
					var itmCodes=Object.keys(res.fControl[p.episodeID]);
					itmCodes.map(function (itmCode,j) {
						if (!singleConfigObj[itmCode]) return;
						if ((singleConfigObj[itmCode].formulaControl=="Y")&&!$("#needMeasure").checkbox('getValue')) {
							if (singleConfigObj[itmCode].yestDesc) {
								patientList[i].fControl[itmCode]=preRes.fControl[p.episodeID][itmCode];
							} else {
								patientList[i].fControl[itmCode]=res.fControl[p.episodeID][itmCode];
							}
						}
					})
				})
			}
			var frozenColumns = [
				[
					{title:$g('床号'),field:'bedCode',width:bedWidth,rowspan:2},
					{title:$g('姓名'),field:'name',width:nameWidth,rowspan:2},
					{title:$g('年龄'),field:'age',width:ageWidth,rowspan:2},
					{title:$g('护理级别'),field:'careLevel',width:careWidth,rowspan:2}
				],
			];
			var timePoint = Object.keys(res);
			if (!needMeasure) timePoint.splice(timePoint.indexOf("fControl"),1);
			multiColumns = [[], []];
			colCodesArr = [];
			var vsItems=[];
			singleConfig.map(function(e) {
				var v=$("#"+e.code).checkbox('getValue');
				if (v) vsItems.push(e.code);
			});
			var morningList=[], afternoonList=[], alldayList=[]; // 上午，下午，全天
			timePoint.map(function (tp,tpIndex) {
				var colspan = 0;
				if (!colCodesObj[tp]) colCodesObj[tp] = {};
				var episodeArr = Object.keys(res[tp]);
				var items = [];
				episodeArr.map(function (ep) {
					var itemArr = Object.keys(res[tp][ep]);
					itemArr.map(function (item) {
						if (-1 == items.indexOf(item)) {
							items.push(item);
						}
					});
				});
				// var items=Object.keys(res[tp][ep0]||[]);
				items.map(function (item) {
					if (vsItems.indexOf(item) > -1) {
						var e = singleConfigObj[item];
						var tmpWidth=e.colWidth||normalWidth;
						if (!e.yestDesc&&e.abbrCode) tmpWidth=e.colWidth||abbrWidth;
						if (!needMeasure&&((1==e.times.length)||(item.indexOf('_Title')>-1))) { // 全天
							alldayList.push({
								title: e.yestDesc||e.abbrCode||e.desc,
								align: "center",
								code: item,
								time: tp,
								width: tmpWidth,
								rowspan: 2,
								styler: function (value, row, index) {
									if (value&&(item.indexOf('_Title')>-1)) return 'background: #e4e4e4!important;';
									if (!needMeasure&&(("undefined" == typeof value)||(""===value))&&row.fControl[item]) {
										if (row.fControl[item].values.length>=singleConfigObj[item].times.length) {
											return { class: "fControl" };
										}
									}
									if (e.normalValueRangFrom || e.normalValueRangTo) {
										if (value == parseFloat(value)) {
											if (
												value < e.normalValueRangFrom ||
												value > e.normalValueRangTo
											) {
												if (!e.yestDesc&&e.abbrCode) {
													return { class: "warning abbrItem" };
												} else {
													return { class: "warning" };
												}
											}
										}
									}
								},
							});
							return;
						}
						if (!needMeasure&&(2==e.times.length)) {
							if (tpIndex<3) { // 上午
								morningList.push({
									title: e.yestDesc||e.abbrCode||e.desc,
									align: "center",
									code: item,
									time: tp,
									width: tmpWidth,
									styler: function (value, row, index) {
										if (!needMeasure&&(("undefined" == typeof value)||(""===value))&&row.fControl[item]) {
											if (row.fControl[item].values.length>=singleConfigObj[item].times.length) {
												return { class: "fControl" };
											}
										}
										if (e.normalValueRangFrom || e.normalValueRangTo) {
											if (value == parseFloat(value)) {
												if (
													value < e.normalValueRangFrom ||
													value > e.normalValueRangTo
												) {
													if (!e.yestDesc&&e.abbrCode) {
														return { class: "warning abbrItem" };
													} else {
														return { class: "warning" };
													}
												}
											}
										}
										var dateValue=new Date(standardizeDate(curDay)+' '+tp).valueOf();
										var inHospDay=row.inHospDateTime.trim()||row.regDateTime.trim();
										// 校验入院时间
										if (inHospDay) {
											inHospDay=inHospDay.split(' ');
											var inHospDTValue=new Date(standardizeDate(inHospDay[0])+' '+inHospDay[1]).valueOf();
											if (inHospDTValue>dateValue) return 'background: #e4e4e4!important;';
										}
										var lastInHospDay=row.lastTimeInHosp;
										// 校验出院时间
										if (lastInHospDay) {
											lastInHospDay=lastInHospDay.split(' ');
											var lastInHospDTValue=new Date(standardizeDate(lastInHospDay[0])+' '+lastInHospDay[1]).valueOf();
											if (lastInHospDTValue<dateValue) return 'background: #e4e4e4!important;';
										}
										// 校验转科时间
										if (!modify&&row.latestTransLocDateTime) {
											var transLocDay=row.latestTransLocDateTime.split(' ');
											var transLocDTValue=new Date(standardizeDate(transLocDay[0])+' '+transLocDay[1]).valueOf();
											if (transLocDTValue>dateValue) return 'background: #e4e4e4!important;';
										}
									},
								});
							} else { // 下午
								afternoonList.push({
									title: e.yestDesc||e.abbrCode||e.desc,
									align: "center",
									code: item,
									time: tp,
									width: tmpWidth,
									styler: function (value, row, index) {
										if (!needMeasure&&(("undefined" == typeof value)||(""===value))&&row.fControl[item]) {
											if (row.fControl[item].values.length>=singleConfigObj[item].times.length) {
												return { class: "fControl" };
											}
										}
										if (e.normalValueRangFrom || e.normalValueRangTo) {
											if (value == parseFloat(value)) {
												if (
													value < e.normalValueRangFrom ||
													value > e.normalValueRangTo
												) {
													if (!e.yestDesc&&e.abbrCode) {
														return { class: "warning abbrItem" };
													} else {
														return { class: "warning" };
													}
												}
											}
										}
										var dateValue=new Date(standardizeDate(curDay)+' '+tp).valueOf();
										var inHospDay=row.inHospDateTime.trim()||row.regDateTime.trim();
										// 校验入院时间
										if (inHospDay) {
											inHospDay=inHospDay.split(' ');
											var inHospDTValue=new Date(standardizeDate(inHospDay[0])+' '+inHospDay[1]).valueOf();
											if (inHospDTValue>dateValue) return 'background: #e4e4e4!important;';
										}
										var lastInHospDay=row.lastTimeInHosp;
										// 校验出院时间
										if (lastInHospDay) {
											lastInHospDay=lastInHospDay.split(' ');
											var lastInHospDTValue=new Date(standardizeDate(lastInHospDay[0])+' '+lastInHospDay[1]).valueOf();
											if (lastInHospDTValue<dateValue) return 'background: #e4e4e4!important;';
										}
										// 校验转科时间
										if (!modify&&row.latestTransLocDateTime) {
											var transLocDay=row.latestTransLocDateTime.split(' ');
											var transLocDTValue=new Date(standardizeDate(transLocDay[0])+' '+transLocDay[1]).valueOf();
											if (transLocDTValue>dateValue) return 'background: #e4e4e4!important;';
										}
									},
								});
							}
							return;
						}
						// var len = colCodesArr.length;
						// colCodesObj[tp][item] = len;
						// colCodesArr.push({
						// 	time: tp,
						// 	item: item,
						// });
						colspan++;
						multiColumns[1].push({
							title: e.yestDesc||e.abbrCode||e.desc,
							// field: "col" + len,
							align: "center",
							code: item,
							time: tp,
							width: tmpWidth,
							styler: function (value, row, index) {
								if ("undefined" == typeof value) return "background: #e4e4e4!important;";
								if (!needMeasure&&(("undefined" == typeof value)||(""===value))&&row.fControl[item]) {
									if (row.fControl[item].values.length>=singleConfigObj[item].times.length) {
										return { class: "fControl" };
									}
								}
								// if (!JSON.parse(row[e.code+'_WriteFlag'])) return 'background: #e4e4e4!important;';
								if (e.normalValueRangFrom || e.normalValueRangTo) {
									if (value == parseFloat(value)) {
										if (
											value < e.normalValueRangFrom ||
											value > e.normalValueRangTo
										) {
											if (!e.yestDesc&&e.abbrCode) {
												return { class: "warning abbrItem" };
											} else {
												return { class: "warning" };
											}
										}
									}
								}
								var dateValue=new Date(standardizeDate(curDay)+' '+tp).valueOf();
								var inHospDay=row.inHospDateTime.trim()||row.regDateTime.trim();
								// 校验入院时间
								if (inHospDay) {
									inHospDay=inHospDay.split(' ');
									var inHospDTValue=new Date(standardizeDate(inHospDay[0])+' '+inHospDay[1]).valueOf();
									if (inHospDTValue>dateValue) return 'background: #e4e4e4!important;';
								}
								var lastInHospDay=row.lastTimeInHosp;
								// 校验出院时间
								if (lastInHospDay) {
									lastInHospDay=lastInHospDay.split(' ');
									var lastInHospDTValue=new Date(standardizeDate(lastInHospDay[0])+' '+lastInHospDay[1]).valueOf();
									if (lastInHospDTValue<dateValue) return 'background: #e4e4e4!important;';
								}
								// 校验转科时间
								if (!modify&&row.latestTransLocDateTime) {
									var transLocDay=row.latestTransLocDateTime.split(' ');
									var transLocDTValue=new Date(standardizeDate(transLocDay[0])+' '+transLocDay[1]).valueOf();
									if (transLocDTValue>dateValue) return 'background: #e4e4e4!important;';
								}
							},
						});
					}
				});
				if (colspan) {
					multiColumns[0].push({
						// title: tp + "点",
						title: tp,
						align: "center",
						halign: "center",
						// width: 125 * colspan,
						colspan: colspan,
					});
					var sortList=multiColumns[1].splice(multiColumns[1].length-colspan,colspan);
					sortList.sort(function (a,b) {
						return vsItems.indexOf(a.code)-vsItems.indexOf(b.code)
					})
					multiColumns[1].push.apply(multiColumns[1],sortList);
				}
			});
			if (morningList.length) {
				multiColumns[0].push({
					title: "上午",
					align: "center",
					halign: "center",
					// width: 125 * colspan,
					colspan: morningList.length,
				});
				morningList.sort(function (a,b) {
					return vsItems.indexOf(a.code)-vsItems.indexOf(b.code)
				})
				multiColumns[1].push.apply(multiColumns[1],morningList);
			}
			if (afternoonList.length) {
				multiColumns[0].push({
					title: "下午",
					align: "center",
					halign: "center",
					// width: 125 * colspan,
					colspan: afternoonList.length,
				});
				afternoonList.sort(function (a,b) {
					return vsItems.indexOf(a.code)-vsItems.indexOf(b.code)
				})
				multiColumns[1].push.apply(multiColumns[1],afternoonList);
			}
			multiColumns[1].map(function(m,i) {
				if (m.code.indexOf('_Title')>-1) {
					colCodesArr.push({
						time: singleConfigObj[m.code.split('_Title')[0]].blankTitleInputTime,
						item: m.code,
					});
				} else {
					colCodesArr.push({
						time: m.time,
						item: m.code,
					});
				}
			})
			if (alldayList.length) {
				alldayList.sort(function (a,b) {
					return vsItems.indexOf(a.code)-vsItems.indexOf(b.code)
				})
				var len=multiColumns[1].length;
				alldayList.map(function (a,i) {
					alldayList[i].field="col" + (len+i);
					colCodesArr.push({
						time: a.time,
						item: a.code,
					});
					patientList.map(function (p, ind) {
						if (singleConfigObj[a.code].yestDesc||(singleConfigObj[a.code+'_Title']&&singleConfigObj[a.code+'_Title'].yestDesc)) {
							if (preRes[a.time][p.episodeID]) {
								var d = preRes[a.time][p.episodeID][a.code];
								if ("undefined" != typeof d) patientList[ind]["col" + (len+i)] = d;
							}
						}else{
							if (res[a.time][p.episodeID]) {
								var d = res[a.time][p.episodeID][a.code];
								if ("undefined" != typeof d) patientList[ind]["col" + (len+i)] = d;
							}
						}
					});
				})
				multiColumns[0].push.apply(multiColumns[0],alldayList);
			}
			multiColumns[1].map(function (a,i) {
				multiColumns[1][i].field="col" + i;
				patientList.map(function (p, ind) {
					if (singleConfigObj[a.code].yestDesc||(singleConfigObj[a.code+'_Title']&&singleConfigObj[a.code+'_Title'].yestDesc)) {
						if (preRes[a.time][p.episodeID]) {
							var d = preRes[a.time][p.episodeID][a.code];
							if ("undefined" != typeof d) patientList[ind]["col" + i] = d;
						}
					}else{
						if (res[a.time][p.episodeID]) {
							var d = res[a.time][p.episodeID][a.code];
							if ("undefined" != typeof d) patientList[ind]["col" + i] = d;
						}
					}
				});
			})
			var itmTitles=res["23:00"];
			if (itmTitles) {
				patientList.map(function (p,i) {
					if(!itmTitles[p.episodeID]) return;
					var titleKeys=Object.keys(itmTitles[p.episodeID]);
					titleKeys.map(function (tk,i2) {
						patientList[i][tk]=res["23:00"][p.episodeID][tk];
						patientList[i][tk+"_yest"]=preRes["23:00"][p.episodeID][tk];
					})
				})
			}
			$("#multiVSTable").datagrid({
				style: "width:98%;",
				singleSelect: true,
				autoSizeColumn: false,
				fitColumns: false,
				pagination: false,
				frozenColumns: frozenColumns,
				columns: multiColumns,
				bodyCls:'table-splitline',
				data: patientList,
				onClickCell: function (index, field, value) {
					$("#mm").hide();
					if ("bedCode" == field || "name" == field) return;
					var bgColor = $(
						'tr[datagrid-row-index="' + index + '"]>td[field="' + field + '"]'
					).css("backgroundColor");
					if ("rgb(228, 228, 228)" == bgColor) return;
					colIndex = parseInt(field.slice(3));
					editMultiTableCell(index, field);
				},
				onDblClickCell: function (index, field, value) {
					var ind=field.slice(3);
					if (value&&(colCodesArr[ind].item.indexOf('_Title')>-1)) {
						var $blankTitle = $(
							'#multiVSPanel tr[datagrid-row-index="' + index + '"]>td[field="'+field+'"]'
						);
						var bgColor = $blankTitle.css("backgroundColor");
						if ("rgb(228, 228, 228)" == bgColor) {
							$blankTitle.css("backgroundColor", "transparent");
							$.messager.popover({
								msg: "如若更改该空白栏标题，则本住院周的数据都将被更改。",
								type: "info",
							});
						}
					}
				},
				onRowContextMenu: function (e, index, row) {
					e.preventDefault();
					EpisodeID = row.episodeID;
					setPatientInfo(EpisodeID);
					$("#mm")
						.css({
							left: e.pageX,
							top: Math.min(e.clientY, window.innerHeight - 155) + "px",
						})
						.show();
				},
				onLoadSuccess: function (data) {
					curEditorTarget="";
					$(".tooltip.tooltip-top").hide();
					updateDomSize();
					showFControlTip();
					setTimeout(updateDomSize, 1000);
				},
			});
		}
	}, 30);
}
function showFControlTip(){
	var $td = $("#multiVSPanel td.fControl");
	$td.mouseenter(function (event) {
		var field = $(this).attr("field");
		var index = $(this).parent().attr("datagrid-row-index");
		if (field.indexOf('col')==0) {
			var item=colCodesArr[field.slice(3)].item;
		} else {
			var item=field;
		}
		var itemsValue=patientList[index].fControl[item];
		var content = "体征项已录入，不允许多次录入！<br>";
		content += "操作时间：" + itemsValue.opeTimes.join('/') + "<br>";
		content += "数据时间：" + itemsValue.dataTimes.join('/') + "<br>";
		content += "数值：" + itemsValue.values.join('/') + "<br>";
		content += "操作用户：" + itemsValue.users.join('/') ;
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
function getPatientsTempDataByTime(){
	var count=0;
	// 获取患者信息
	var nodes=$('#mvsLayout #patientTree').tree('getChecked'),episodeIDs=[];
	for (var i = 0; i < nodes.length; i++) {
		if ((nodes[i].episodeID)&&($(nodes[i].target).css('display')!="none")) {
			episodeIDs.push(nodes[i].episodeID);
		} else {
			nodes.splice(i,1);
			i--;
		}
	}
	$cm({
		ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
		MethodName: 'GetPatientsByEpisodeIDs',
		EpisodeIDs: episodeIDs.join('^')
	}, function(res) {
		patientList=res;
		res.map(function (r) {
			patientObj[r.episodeID]={
				name:r.name,
				bedCode:r.bedCode,
			}
		})
		count++;
  	});
	var curDay=$('#currentDay').datebox('getValue');
	var newDay=Date.parse(standardizeDate(curDay))-24 * 3600 * 1000;
	var preDay=formatDate(new Date(newDay));
	var curTime=$("#timePoint").timespinner('getValue');
	var needMeasure=$("#needMeasure").checkbox('getValue')?session['LOGON.CTLOCID']:'';
	var preRes,res;
	$cm({
		ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
		MethodName: 'GetPatientsTempDataByTime',
		episodeIDString: JSON.stringify(episodeIDs),
		date: preDay,
		time: curTime,
		LocId: needMeasure,
	}, function (data) {
		preRes=data;
		count++;
	});
	$cm({
		ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
		MethodName: 'GetPatientsTempDataByTime',
		episodeIDString: JSON.stringify(episodeIDs),
		date: curDay,
		time: curTime,
		LocId: needMeasure,
	}, function (data) {
		res=data;
		count++;
  	});
	var timer=setInterval(function() {
		if (count>2) {
			clearInterval(timer);
			vitalsignData=res;
			var data=[];
			curDay=standardizeDate(curDay);
			res.map(function(e, i) {
				var keys=Object.keys(e);
				var vsdata={
					// bedCode:nodes[i].bedCode,
					// name:nodes[i].name,
					// episodeID:nodes[i].episodeID
					bedCode:patientList[i].bedCode,
					name:patientList[i].name,
					age:patientList[i].age,
					careLevel:patientList[i].careLevel,
					episodeID:patientList[i].episodeID,
					inHospDateTime:patientList[i].inHospDateTime||patientList[i].inDeptDateTime,
					lastTimeInHosp:patientList[i].lastTimeInHosp,
					regDateTime:patientList[i].regDateTime||"",
					latestTransLocDateTime:patientList[i].latestTransLocDateTime
				}
				keys.map(function(k) {
					var kT=k+'_Title';
					if ((singleConfigObj[k]&&singleConfigObj[k].yestDesc)||(singleConfigObj[kT]&&singleConfigObj[kT].yestDesc)) {
						vsdata[k]=preRes[i][k].value;
						vsdata[k+'_WriteFlag']=preRes[i][k].writeFlag;
					} else {
						vsdata[k]=e[k].value;
						vsdata[k+'_WriteFlag']=e[k].writeFlag;
					}
				})
				data.push(vsdata);
				if (e.fControl) {
					patientList.map(function (p,ind) {
						patientList[ind].fControl={}
						var itmCodes=Object.keys(e.fControl);
						itmCodes.map(function (itmCode,j) {
							if ((singleConfigObj[itmCode].formulaControl=="Y")&&!$("#needMeasure").checkbox('getValue')) {
								if (singleConfigObj[itmCode].yestDesc) {
									patientList[ind].fControl[itmCode]=preRes[ind].fControl[itmCode];
								} else {
									patientList[ind].fControl[itmCode]=res[ind].fControl[itmCode];
								}
							}
						})
					})
				}
			})
			var frozenColumns=[
				[
					{title:$g('床号'),field:'bedCode',width:bedWidth},
					{title:$g('姓名'),field:'name',width:nameWidth},
					{title:$g('年龄'),field:'age',width:ageWidth},
					{title:$g('护理级别'),field:'careLevel',width:careWidth}
				]
			];
			multiColumns=[];
			colCodes=[];
			singleConfig.map(function(e) {
				var v=$("#"+e.code).checkbox('getValue');
				if (v) {
					var col={title:e.desc,field:e.code,width:e.colWidth||normalWidth,styler: function (value, row, index) {
						if (value&&(e.code.indexOf('_Title')>-1)) return 'background: #e4e4e4!important;';
						if (!needMeasure&&(("undefined" == typeof value)||(""===value))&&patientList[index].fControl[e.code]) {
							if (patientList[index].fControl[e.code].values.length>=singleConfigObj[e.code].times.length) {
								return { class: "fControl" };
							}
						}
						if (!JSON.parse(row[e.code+'_WriteFlag'])) return 'background: #e4e4e4!important;';
						if (e.normalValueRangFrom || e.normalValueRangTo) {
							if (value==parseFloat(value)) {
								if (value < e.normalValueRangFrom || value > e.normalValueRangTo) {
									// return 'color: rgb(246, 164, 5);border: 1px solid rgb(246, 164, 5)!important;';
									// if (!e.yestDesc&&e.abbrCode) {
									// 	return { class: "warning abbrItem" };
									// } else {
									// 	return { class: "warning" };
									// }
									return { class: "warning" };
								}
							}
						}
						var dateValue=new Date(curDay+' '+curTime).valueOf();
						var inHospDay=row.inHospDateTime.trim()||row.regDateTime.trim();
						// 校验入院时间
						if (inHospDay) {
							inHospDay=inHospDay.split(' ');
							var inHospDTValue=new Date(standardizeDate(inHospDay[0])+' '+inHospDay[1]).valueOf();
							if (inHospDTValue>dateValue) return 'background: #e4e4e4!important;';
						}
						var lastInHospDay=row.lastTimeInHosp;
						console.log(lastInHospDay);
						// 校验出院时间
						if (lastInHospDay) {
							lastInHospDay=lastInHospDay.split(' ');
							var lastInHospDTValue=new Date(standardizeDate(lastInHospDay[0])+' '+lastInHospDay[1]).valueOf();
							if (lastInHospDTValue<dateValue) return 'background: #e4e4e4!important;';
						}
						// 校验转科时间
						if (!modify&&row.latestTransLocDateTime) {
							var transLocDay=row.latestTransLocDateTime.split(' ');
							var transLocDTValue=new Date(standardizeDate(transLocDay[0])+' '+transLocDay[1]).valueOf();
							if (transLocDTValue>dateValue) return 'background: #e4e4e4!important;';
						}
					}};
					// if (e.abbrCode) {
					// 	col.width=e.colWidth||abbrWidth;
					// 	col.title=e.abbrCode;
					// }
					if (e.yestDesc) {
						col.width=e.colWidth||normalWidth;
						col.title=e.yestDesc;
					}
					multiColumns.push(col);
					colCodes.push(e.code);
				}
			});
			var itmKeys=Object.keys(res[0]);
			patientList.map(function (p,i) {
				itmKeys.map(function (ik,i2) {
					if (ik.indexOf('_Title')<0) return;
					patientList[i][ik]=res[i][ik].value||'';
					patientList[i][ik+"_yest"]=preRes[i][ik].value||'';
				})
			})
			$('#multiVSTable').datagrid({
				style:'width:98%;',
				singleSelect:true,
				autoSizeColumn:false,
				fitColumns:false,
				pagination:false,
				frozenColumns:frozenColumns,
				columns:[multiColumns],
				data:data,
				onClickCell:function(index, field, value) {
					$('#mm').hide();
					if (("bedCode"==field)||("name"==field)) return;
					var bgColor=$('tr[datagrid-row-index="'+index+'"]>td[field="'+field+'"]').css('backgroundColor');
					if ('rgb(228, 228, 228)'==bgColor) return;
					colIndex=colCodes.indexOf(field);
					editTableCell(index, field);
				},
				onDblClickCell:function(index, field, value) {
					if (value&&(field.indexOf('_Title')>-1)) {
						var $blankTitle=$('tr[datagrid-row-index="'+index+'"]>td[field="'+field+'"]');
						var bgColor=$blankTitle.css('backgroundColor');
						if ('rgb(228, 228, 228)'==bgColor) {
							$blankTitle.css('backgroundColor','transparent');
							$.messager.popover({msg: $g('如若更改该空白栏标题，则本住院周的数据都将被更改。'),type:'info'});
						}
					}
				},
				onRowContextMenu:function(e,index,row){
					e.preventDefault();
					EpisodeID=row.episodeID;
					setPatientInfo(EpisodeID)
					$('#mm').css({
						left: e.pageX,
						top: Math.min(e.clientY, window.innerHeight - 155) + "px"
					}).show();
					endEditTableCell();
				},
				onLoadSuccess: function(data){
					curEditorTarget="";
					$(".tooltip.tooltip-top").hide();
					updateDomSize();
					showFControlTip();
					setTimeout(updateDomSize,500);
				}
			});
			$('#mm').hide();
		}
	}, 30);
}
function onPrintBtnClick() {
	if ($("#switch").switchbox('getValue')) {
		var date=$('#currentDay').datebox('getValue');
		var printFlag=1;
		var patCount=0;
		patientList.map(function (e,i) {
			var j=i;
			$cm({
				ClassName: 'NurMp.Discharge.Authority',
				MethodName: 'getPatAction',
				dataType: "text",
				EpisodeId: e.episodeID,
				STDate: date,
				MouldType: "SMTZ",
				UserID: session['LOGON.USERID'],
				Action: "print",
			}, function (data) {
				data=parseInt(data);
				printFlag=printFlag&&data;
				if (1!=data) {
					$.messager.popover({msg: patientList[j].name+$g('出院病历未对此操作授权。'),type:'alert'});
	                return;
				}
				patCount++;
			});
		})
		var paTimer=setInterval(function() {
	        if (!printFlag) clearInterval(paTimer);
			if (patientList.length==patCount) {
				clearInterval(paTimer);
				onPrintByDay();
			}
		}, 100);
		return;
	}else {
		var measureFlag=$("#needMeasure").checkbox('getValue'); // 需测标识
		var episodeIDArray = [];
		var printCodes = [];
		if (measureFlag) {
			var nodes=$('#mvsLayout #patientTree').tree('getChecked'),episodeIDs=[];
			for (var i = 0; i < nodes.length; i++) {
				if (nodes[i].episodeID) {
					episodeIDs.push(nodes[i].episodeID);
				} else {
					nodes.splice(i,1);
					i--;
				}
			}
			var vsData=JSON.parse(JSON.stringify(vitalsignData));
			for (var i = 0; i < vsData.length; i++) {
				var keys=Object.keys(vsData[i]);
				for (var j = 0; j < keys.length; j++) {
					if ((colCodes.indexOf(keys[j])==-1)||("false"==vsData[i][keys[j]].writeFlag)) {
						delete vsData[i][keys[j]];
					}else if (printCodes.indexOf(keys[j])==-1){
						printCodes.push(keys[j])
					}
				}
				if (0==Object.keys(vsData[i]).length) {
					episodeIDs.splice(i,1);
					vsData.splice(i,1);
					i--;
				}
			}
			// 按colCodes顺序排序
			printCodes.sort(function(a,b) {
				return colCodes.indexOf(a)-colCodes.indexOf(b)
			})
			episodeIDArray=episodeIDs;
		} else {
			var rows=$('#multiVSTable').datagrid('getRows');
			rows.forEach(function(row) {
				episodeIDArray.push(row.episodeID);
			});
			printCodes = colCodes;
		}
		var date=$('#currentDay').datebox('getValue');
		var time=$('#timePoint').timespinner('getValue');
		var printFlag=1;
		var patCount=0;
		episodeIDArray.map(function (e,i) {
			var j=i;
			$cm({
				ClassName: 'NurMp.Discharge.Authority',
				MethodName: 'getPatAction',
				dataType: "text",
				EpisodeId: e,
				STDate: date,
				STTime: time,
				MouldType: "SMTZ",
				UserID: session['LOGON.USERID'],
				Action: "print",
			}, function (data) {
				data=parseInt(data);
				printFlag=printFlag&&data;
				if (1!=data) {
					$.messager.popover({msg: patientList[j].name+$g('出院病历未对此操作授权。'),type:'alert'});
	                return;
				}
				patCount++;
			});
		})
		var paTimer=setInterval(function() {
	        if (!printFlag) clearInterval(paTimer);
			if (episodeIDArray.length==patCount) {
				clearInterval(paTimer);
				onPrintByTime();
			}
		}, 100);
	}
}
function onPrintByTime() {
	var measureFlag=$("#needMeasure").checkbox('getValue'); // 需测标识
	var episodeIDArray = [];
	var printCodes = [];
	if (measureFlag) {
		var nodes=$('#mvsLayout #patientTree').tree('getChecked'),episodeIDs=[];
		for (var i = 0; i < nodes.length; i++) {
			if (nodes[i].episodeID) {
				episodeIDs.push(nodes[i].episodeID);
			} else {
				nodes.splice(i,1);
				i--;
			}
		}
		var vsData=JSON.parse(JSON.stringify(vitalsignData));
		for (var i = 0; i < vsData.length; i++) {
			var keys=Object.keys(vsData[i]);
			for (var j = 0; j < keys.length; j++) {
				if ((colCodes.indexOf(keys[j])==-1)||("false"==vsData[i][keys[j]].writeFlag)) {
					delete vsData[i][keys[j]];
				}else if (printCodes.indexOf(keys[j])==-1){
					printCodes.push(keys[j])
				}
			}
			if (0==Object.keys(vsData[i]).length) {
				episodeIDs.splice(i,1);
				vsData.splice(i,1);
				i--;
			}
		}
		// 按colCodes顺序排序
		printCodes.sort(function(a,b) {
			return colCodes.indexOf(a)-colCodes.indexOf(b)
		})
		episodeIDArray=episodeIDs;
	} else {
		var rows=$('#multiVSTable').datagrid('getRows');
		rows.forEach(function(row) {
			episodeIDArray.push(row.episodeID);
		});
		printCodes = colCodes;
	}
	var date=$('#currentDay').datebox('getValue');
	var time=$('#timePoint').timespinner('getValue');
	var tableStr=[];
	for (var i = 0; i < printCodes.length; i=i+5) {
		var tmpCodes=printCodes.slice(i,i+5)
		var tmpStr=$cm({
			ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
			MethodName: 'GetPrintPats',
			EpisodeIDs: episodeIDArray.join("^"),
			dataType: "text",
			Date: date,
			Time: time,
			Codes: tmpCodes.join("^")
		}, false);
		if (measureFlag) {
			var tmpStrs=tmpStr.split('\n');
			// var $div=$('<div>'+tmpStr+'</div>');
			for (var j = 0; j < vsData.length; j++) {
				for (var k = 0; k < tmpCodes.length; k++) {
					var start=-1;
					if (!vsData[j][tmpCodes[k]]) {
						var steps=k+3
						while (steps--) {
							start++;
							start=tmpStrs[j+1].indexOf('<td',start)
						}
						tmpStrs[j+1]=tmpStrs[j+1].slice(0,start)+'<td style="background:#e4e4e4!important;">'+tmpStrs[j+1].slice(start+4);
					}
				}
			}
			tableStr.push(tmpStrs.join('\n'));
		} else {
			var $table=$('<div>'+tmpStr+'</div>');
			$('#multiVSPanel td.fControl').map(function (i,obj) {
				var trIndex=$(obj).parent().index();
				var tdIndex=$(obj).index()+3;
				$table.find('tbody>tr:eq('+trIndex+')>td:eq('+tdIndex+')').attr('style','background:#e4e4e4!important');
			})
			tableStr.push($table.html());
		}
	}
	var LODOP = getLodop();
	LODOP.PRINT_INIT("打印待测患者列表");
	LODOP.SET_PRINT_PAGESIZE(0, 0, 0, "A4");
	var pageSize=Math.ceil(episodeIDArray.length/40);
	for (var i = 0; i < tableStr.length; i++) {
		if (i) {
			LODOP.NEWPAGE();
			for (var j = 1; j < pageSize; j++) {
				LODOP.NEWPAGE();
			}
		}
		LODOP.ADD_PRINT_TABLE("30mm", "10mm", "180mm", "230mm", tableStr[i]);
	}
	LODOP.ADD_PRINT_TEXT("10mm", 277, 154, 32, "待测患者列表\n");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 15);
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
	LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
	LODOP.ADD_PRINT_TEXT("20mm", "10mm", 100, 25, "待测日期:");
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
	LODOP.ADD_PRINT_TEXT("20mm", "25mm", 100, 25, date);
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
	LODOP.ADD_PRINT_TEXT("20mm", "50mm", 100, 25, "待测时间:");
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
	LODOP.ADD_PRINT_TEXT("20mm", "66mm", 74, 25, time);
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
	LODOP.PREVIEW();
}
function onPrintByDay(blankFlag) {
	var measureFlag=$("#needMeasure").checkbox('getValue');
    var episodeIDArray = [];
	patientList.forEach(function(row) {
		episodeIDArray.push(row.episodeID);
	});
	var tableStart='<table border="1" width="100%" style="border:solid 1px black;border-collapse:collapse;width:100%;"><thead><tr><th rowspan="2">床号</th><th rowspan="2">姓名</th><th rowspan="2" style="width:40px;">护理<br>级别</th>';
	var colLen=10; // 每行显示的列数（不包括固定的3列）
	var columns=JSON.parse(JSON.stringify(multiColumns));
	var date=$('#currentDay').datebox('getValue');
	var time=$('#timePoint').timespinner('getValue');
	var tableStr=[];
	var start=0,end,bigEnd=columns[1].length;
	columns[0].map(function(c){
		if (c.time) {
			bigEnd++;
		}
	})
	while (columns[0].length) {
		end=Math.min(start+colLen,bigEnd);
		var count=colLen,table=tableStart,cols=[],col1=[],col2=[];
		while (count&&columns[0].length) {
			var colspan=columns[0][0].colspan||1;
			if (colspan<=count) {
				count=count-colspan;
				if (columns[0][0].time) { //colspan是1
					cols.push(columns[0][0]);
					col1.push(columns[0][0]);
				} else {
					col1.push(columns[0][0]);
					while (colspan) {
						var obj=columns[1].shift();
						cols.push(obj);
						col2.push(obj);
						colspan--;
					}
				}
				columns[0].shift();
			} else {
				columns[0][0].colspan=colspan-count;
				var obj=JSON.parse(JSON.stringify(columns[0][0]));
				obj.colspan=count;
				col1.push(obj);
				while (count) {
					obj=columns[1].shift();
					cols.push(obj);
					col2.push(obj);
					count--;
				}
			}
		}
		col1.map(function(c){
			table+='<th colspan="'+(c.colspan||1)+'" rowspan="'+(c.rowspan||1)+'">'+c.title+'</th>';
		})
		table+='</tr><tr>';
		col2.map(function(c){
			table+='<th>'+c.title+'</th>';
		})
		table+='</tr>';
		// patientList.map(function(p,pInd){
		// 	table+='<tr><td>'+p.bedCode+'</td><td>'+p.name+'</td><td>'+p.careLevel.slice(0,2)+'</td>';
		// 	for (var i = start; i < end; i++) {
		// 		if (('undefined'==typeof p['col'+i])||$('.datagrid-view2 .datagrid-body tbody>tr:eq('+pInd+')>td:eq('+i+')').hasClass('fControl')) {
		// 			table+='<td style="background:#e4e4e4!important;"></td>';
		// 		} else {
		// 			table+='<td>'+p['col'+i]+'</td>';
		// 		}
		// 	}
		// 	table+='</tr>';
		// })
		// tableStr.push(table);
		var newTable=table;
		var patSize=25; // 每页打印多少个患者
		patientList.map(function(p,pInd){
			newTable+='<tr><td>'+p.bedCode+'</td><td>'+p.name+'</td><td>'+p.careLevel.slice(0,2)+'</td>';
			for (var i = start; i < end; i++) {
				if (('undefined'==typeof p['col'+i])||$('.datagrid-view2 .datagrid-body tbody>tr:eq('+pInd+')>td:eq('+i+')').hasClass('fControl')) {
					newTable+='<td style="background:#e4e4e4!important;"></td>';
				} else {
					newTable+='<td>'+p['col'+i]+'</td>';
				}
			}
			newTable+='</tr>';
			if (!((pInd+1)%patSize)||(pInd==(patientList.length-1))) {
				tableStr.push(newTable);
				newTable=table;
			}
		})
		// tableStr.push(newTable);
		start=start+colLen;
	}
	var LODOP = getLodop();
	LODOP.PRINT_INIT("打印待测患者列表");
	// LODOP.SET_PRINT_PAGESIZE(2, 0, 0, "A4");
	LODOP.SET_PRINT_PAGESIZE(2, 2970, 2100, "");
	var pageSize=Math.ceil(episodeIDArray.length/25);
	for (var i = 0; i < tableStr.length; i++) {
		if (i) {
			LODOP.NEWPAGE();
		}
		LODOP.ADD_PRINT_TABLE("30mm", "10mm", "267mm", "180mm", tableStr[i]);
	}
	LODOP.ADD_PRINT_TEXT("10mm", 277, 154, 32, "待测患者列表\n");
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 15);
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
	LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
	LODOP.ADD_PRINT_TEXT("20mm", "10mm", 100, 25, "待测日期:");
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
	LODOP.ADD_PRINT_TEXT("20mm", "25mm", 100, 25, date);
	LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
	LODOP.SET_PRINT_STYLEA(0, "FontSize", 10);
	LODOP.PREVIEW();
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
function showQCModal() {
	$('#qcStartDate').datebox('setValue', formatDate(new Date(),-6));
	$('#qcEndDate').datebox('setValue', formatDate(new Date()));
	getQCList();
}
function getQCList(f) {
	// 获取患者信息
	var nodes=$('#mvsLayout #patientTree').tree('getChecked'),episodeIDs=[];
	for (var i = 0; i < nodes.length; i++) {
		if ((nodes[i].episodeID)&&($(nodes[i].target).css('display')!="none")) {
			episodeIDs.push(nodes[i].episodeID);
		} else {
			nodes.splice(i,1);
			i--;
		}
	}
	if (!episodeIDs.length) {
		$.messager.popover({msg: $g('请先选择患者！'),type:'alert'});
		return false;
	}
	updateModalPos("qcModal");
	var startdate=$("#qcStartDate").datebox("getValue");
	var enddate=$("#qcEndDate").datebox("getValue");
	if (!startdate||!enddate) {
		$.messager.popover({msg: $g('请选择完整的日期！'),type:'alert'});
		return false;
	}
	var data={
		EpisodeIDs:episodeIDs.join("^"),
		WardID:session['LOGON.WARDID'],
		UserId:session['LOGON.USERID'],
		LocID:session['LOGON.CTLOCID'],
		HospDR:session['LOGON.HOSPID'],
		GroupID:session['LOGON.GROUPID'],
		StartDate:startdate,
		StartTime:"00:00",
		EndDate:enddate,
		EndTime:"23:59",
		TaskType:1,
	}
	var res;
	// qcNewFlag=0;
	if (1==qcNewFlag) {
		data.ItemId=""
		res=$cm({
			ClassName: 'Nur.NIS.Service.NursingTask.Controller',
			MethodName: 'GetNursingTaskRecord',
			data:JSON.stringify(data)
		}, false);
	} else {
		data.ClassName='Nur.NIS.Service.ExecuteSummary.NeedExeTask';
		data.MethodName='NormalTaskProcessInit';
		res=$cm(data, false);
	}
	var qcCol=[
		{title: $g("床号"), field: "bedCode", align:'center', width: 50},
		{title: $g("姓名"), field: "patName", width: 100},
		{title: $g("体征项"), field: "vsItm", width: 100},
		{title: $g("需测日期"), field: "nmDate", width: 100},
		{title: $g("需测时间"), field: "nmTime", width: 80},
		{title: $g("需测规则")+'<a href="#" id="nmRuletip" class="hisui-linkbutton" data-options="iconCls:\'icon-help\',plain:true"></a>', field: "nmRule", width: 200},
		{title: $g("是否填写"), field: "hasDone", align:'center', width: 78,formatter:function (value,row,index) {
			return row.value?$g("已填"):$g("未填");
		}}
	];
	var data=[];
	var notFillVal=$("#notFilled").checkbox('getValue');
	if (1==qcNewFlag) {
		// if (notFillVal) {
		// 	var qcData=res.patNeedExeList;
		// } else {
		// 	var qcData=res.patAllExeList;
		// }
		// qcData.map(function(r) {
		// 	r.list.map(function(l) {
		// 		l.tkDataList.map(function(t) {
		// 			if (notFillVal&&t.value) return;
		// 			var pointDate=t.pointDate.split(' ');
		// 			data.push({
		// 				bedCode:l.bedCode||"",
		// 				patName:l.patName||"",
		// 				vsItm:l.exeItemName||"",
		// 				nmDate:pointDate[0],
		// 				nmTime:pointDate[1],
		// 				nmRule:t.desc||"",
		// 				value:t.value||"",
		// 			})
		// 		});
		// 	});
		// });
		res.map(function(r) {
			if (notFillVal&&r.itemValue) return;
			var nmRule="";
			r.pointTaskList.map(function(p) {
				nmRule+=p.desc+";";
			});
			nmRule=nmRule.slice(0,-1);
			data.push({
				bedCode:r.bedCode||"",
				patName:r.patName||"",
				vsItm:r.itemName||"",
				nmDate:r.exeDate,
				nmTime:r.exeTime,
				nmRule:nmRule,
				value:r.itemValue||"",
			})
		});
	} else {
		if (notFillVal) {
			var qcData=res.body.unexec;
		} else {
			var qcData=res.body.all;
		}
		qcData.map(function(r) {
			r.list.map(function(l) {
				data.push({
					bedCode:patientObj[l.episodeID].bedCode||"",
					patName:patientObj[l.episodeID].name||"",
					nmRule:l.taskDesc,
					vsItm:singleConfigObj[l.itemCode].desc,
					nmDate:l.dateStr,
					nmTime:l.timeStr,
					value:l.value,
				})
			});
		});
	}
	$('#qualityControl').datagrid({
		columns :[qcCol],
		rownumbers:true,
		pageSize:qcPageSize,
		data:{total:data.length,rows:data},
		onLoadSuccess:function(data){
			setTimeout(function() {
				updateModalPos("qcModal");
			}, 300);
			$("#nmRuletip").linkbutton().popover({
				trigger:'hover',
				content:"<p>"+$g('来自“常规护理任务配置-常规护理任务描述”')+"</p>",
				style:'inverse'
			});
		}
	}).datagrid({loadFilter:DocToolsHUI.lib.pagerFilter});
	updateModalPos("qcModal");
}
// 单人体征
function openSingleVSModal() {
	var innerWidth=window.innerWidth-50;
	var innerHeight=window.innerHeight-50;
	$('#singleVSModal').dialog({
		width: innerWidth,
		height: innerHeight,
	}).dialog("open");
	var url='nur.hisui.singlevitalsign.csp?EpisodeID='+EpisodeID+'&IsShowPatInfoBannner=Y';
	$("#singleVSModal iframe").css('height','calc(100% - 0px)').attr('src',url);
}
function preShow() {
	var url = "nur.hisui.temperature.linux.csp"+"?EpisodeID="+EpisodeID;
	if ("undefined" != typeof websys_getMWToken) {
		url += "&MWToken=" + websys_getMWToken();
	}
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
function saveTableCell(f) {
	if ($("#switch").switchbox('getValue')) {
		endEditMultiTableCell(f);
	} else {
		endEditTableCell(f);
	}
}
function endEditMultiTableCell(flag) {
	if (curEditorTarget) {
		var tmpEditorTarget=curEditorTarget;
		setTimeout(function() {
			$(tmpEditorTarget).tooltip("hide");
				$(".tooltip").hide();
			$(curEditorTarget).focus().tooltip("show");
		}, 300);
	}
	var rows = $("#multiVSTable").datagrid("getRows");
	// 结束编辑
	for (var i = 0, len = rows.length; i < len; i++) {
		e = rows[i];
		var ed = $("#multiVSTable").datagrid("getEditors", i)[0]; // 获取编辑器
		if (ed) {
			var colObj = colCodesArr[ed.field.slice(3)];
			e = singleConfigObj[colObj.item];
			if (e.select) {
				var value = $(ed.target).combobox("getValue");
				if ((''===value)&&("Y"==e.udFlag)) {
					value=$(ed.target).combobox('textbox').val();
					$(ed.target).combobox("setValue",value);
				}
			} else {
				var value = $(ed.target).val();
			}
			if (e.validate && "" !== value) {
				var symbol = e.symbol;
				if (!symbol || symbol.indexOf(value) < 0) {
					if (e.errorValueHightFrom || e.errorValueLowTo) {
						if (value != parseFloat(value)) {
							$.messager.popover({ msg: "请填写正确的数值！", type: "alert" });
							return false;
						} else {
							value=parseFloat(value);
						}
						if (value > e.errorValueHightFrom || value < e.errorValueLowTo) {
							$(ed.target).addClass('error');
							$.messager.popover({
								msg: "填写的值超出正确范围！",
								type: "alert",
							});
							return false;
						}
					}
					if (value == parseFloat(value)) {
						if (value < e.normalValueRangFrom || value > e.normalValueRangTo) {
							$(ed.target).addClass('warning');
						}
					}
				}
			}
			var eTitle=singleConfigObj[colObj.item+"_Title"];
			if (eTitle&&(''!==value)) {
				if (e.yestDesc&&!patientList[i][colObj.item+"_Title_yest"]) {
					$.messager.popover({msg: $g('录入空白栏数据前请先录入空白栏标题！'),type:'alert'});
					return false;
				}
				// if ((e.yestDesc&&eTitle.yestDesc)||(!e.yestDesc&&!eTitle.yestDesc)) {
				if (!e.yestDesc&&!patientList[i][colObj.item+"_Title"]) {
					$.messager.popover({msg: $g('录入空白栏数据前请先录入空白栏标题！'),type:'alert'});
					return false;
				}
			}
      		var date = $('#currentDay').datebox('getValue');
			// if (e.yestDesc||(eTitle&&eTitle.yestDesc)) {
			if (e.yestDesc) {
				var newDay=Date.parse(standardizeDate(date))-24 * 3600 * 1000;
				date=formatDate(new Date(newDay));
			}
			if ((singleConfigObj[colObj.item].formulaControl=="Y")&&!$("#needMeasure").checkbox('getValue')) {
				checkFormulaControl(patientList[i][ed.field],value,i,ed.field)
			}
			var res = $cm({
				ClassName: "Nur.NIS.Service.VitalSign.Temperature",
				MethodName: "SaveObsDataByDay",
				dataType: "text",
				episodeID: rows[i].episodeID,
				modifyData: JSON.stringify([
					{
						code: colObj.item,
						value: value,
						time: colObj.time,
					},
				]),
				userID: session["LOGON.USERID"],
				date: date,
				userLocID: session["LOGON.CTLOCID"],
				wardID: session["LOGON.WARDID"],
			}, false);
			if ('-1000'==res) {
				$('#multiVSTable').datagrid('endEdit', i);
				applyAuthority(rows[i]);
			} else if (0==parseInt(res)) {
				if (res.toString().indexOf('^')>-1) {
					$.messager.popover({msg: $g(res.split('^')[1]),type:'alert'});
				}else if (1==flag) {
					$.messager.popover({msg: $g('数据保存成功'),type:'success'});
				}
				if(subScreen) {
					window.parent.websys_emit("vitalSignChange",{});
				}
				// 将空白栏标题的修改值保存到patientList里，以方便校验空白栏的录入
				if (colObj.item.indexOf('_Title')>-1) {
					if (e.yestDesc) {
						patientList[i][colObj.item+"_yest"]=value;
					} else {
						patientList[i][colObj.item]=value;
					}
				}
				// 更新控制体征项录入频次的数据
				if ((singleConfigObj[colObj.item].formulaControl=="Y")&&!$("#needMeasure").checkbox('getValue')) {
					patientList[i][ed.field]=value;
					updateFormulaControlData(i,date,colObj.item);
				}
			} else {
				$.messager.popover({ msg: res, type: "alert" });
				return false;
			}
			if (2 != flag) {
				$("#multiVSTable").datagrid("endEdit", i);
			}
			// 更新控制体征项录入频次的数据
			if ((singleConfigObj[colObj.item].formulaControl=="Y")&&!$("#needMeasure").checkbox('getValue')) {
				updateFormulaControlData(i,date,colObj.item);
			}
			updateDomSize();
			return true;
		}
	}
	return true;
}
function checkFormulaControl(oldVal,newVal,i,field) {
	var colIndex=field.slice(3);
	var item = colCodesArr[colIndex].item;
	var e = singleConfigObj[item];
	if ((''===oldVal)&&(''!==newVal)) { // 添加数据
		if (patientList[i].fControl&&patientList[i].fControl[item]&&((patientList[i].fControl[item].values.length+1)>=e.times.length)) {
			colCodesArr.map(function (colCode,ind) {
				var newField='col'+ind;
				if ((item==colCode.item)&&(''===patientList[i][newField])&&(colIndex!=ind)) {
					$('tr[datagrid-row-index="'+i+'"] td[field="'+newField+'"]').addClass('fControl');
				}
			})
		}
	}
	if ((''!==oldVal)&&(''===newVal)) { // 删除数据
		if (patientList[i].fControl&&patientList[i].fControl[item]&&((patientList[i].fControl[item].values.length-1)<e.times.length)) {
			colCodesArr.map(function (colCode,ind) {
				var newField='col'+ind;
				if ((item==colCode.item)&&(''===patientList[i][newField])&&(colIndex!=ind)) {
					$('tr[datagrid-row-index="'+i+'"] td[field="'+newField+'"]').removeClass('fControl');
				}
			})
		}
	}
}
function updateFormulaControlData(i, date, item) {
	var res = $cm(
		{
			ClassName: "Nur.NIS.Service.VitalSign.Temperature",
			MethodName: "GetFormulaControlData",
			episodeID: patientList[i].episodeID,
			date: date,
			item: item,
			userLocID: session["LOGON.CTLOCID"],
		},
		false
	);
	if(patientList[i].fControl) patientList[i].fControl[item]=res[item];
	showFControlTip();
	// $("#multiVSTable").datagrid('loadData',{rows:patientList})
}
function forwardMultiTableCell(index, field, keyCode) {
	originColIndex=colIndex;
	var rows = $("#multiVSTable").datagrid("getRows"),
		row = rows[index];
	var colspan;
	switch (keyCode) {
		case 38: //上
			if (0 == index) {
				index = rows.length - 1;
				if (0 == colIndex) {
					colIndex = colCodesArr.length - 1;
				} else {
					colIndex--;
				}
			} else {
				index--;
			}
			break;
		case 40: //下
			if (index == rows.length - 1) {
				index = 0;
				if (colCodesArr.length - 1 == colIndex) {
					colIndex = 0;
				} else {
					colIndex++;
				}
			} else {
				index++;
			}
			break;
		case 37: //左
			if (0 == colIndex) {
				if (0 == index) {
					index = rows.length - 1;
				} else {
					index--;
				}
				colIndex = colCodesArr.length - 1;
			} else {
				colIndex--;
			}
			break;
		case 39: //右
			if (colIndex == colCodesArr.length - 1) {
				colIndex = 0;
				if (index == rows.length - 1) {
					index = 0;
				} else {
					index++;
				}
			} else {
				colIndex++;
			}
			break;
		default:
			return;
	}
	field = "col" + colIndex;
	editMultiTableCell(index, field, keyCode);
}
function editMultiTableCell(index, field, keyCode) { // 多时间点
	var saveRes = endEditMultiTableCell();
	if (!saveRes) {
		colIndex=originColIndex;
		return;
	}
	var $td = $(
		'tr[datagrid-row-index="' + index + '"]>td[field="' + field + '"]'
	);
	var bgColor = $td.css("backgroundColor");
	if ("rgb(228, 228, 228)" == bgColor) {
		if (keyCode) {
			forwardMultiTableCell(index, field, keyCode);
		}
		return;
	}
	if (subScreen) {
		var episodeId=patientList[index].episodeID;
		var curDay=$('#currentDay').datebox('getValue');
		if ((secondScreen.EpisodeID!=episodeId)||(secondScreen.Date!=curDay)) {
			secondScreen.EpisodeID=episodeId;
			secondScreen.Date=curDay;
			window.parent.websys_emit("onOpenTempPreview",{EpisodeID:episodeId,MWToken:websys_getMWToken(),Date:curDay});
		}
	}
	var rows = $("#multiVSTable").datagrid("getRows"),
		row = rows[index];
	var vsItemCode = colCodesArr[colIndex].item;
	var vsItem = singleConfigObj[vsItemCode];
	var tipId = vsItem.code + "Tip";
	if (vsItem.symbol && !$("#" + tipId).length) {
		var tipDom = '<div id="' + tipId + '">';
		vsItem.symbol.map(function (e) {
		tipDom +=
			'<a href="#" name="symbol" class="easyui-linkbutton" data-options="plain:true" data-text="' +
			e +
			'"></a>';
		});
		tipDom += "</div>";
		$("#toolTips").append(tipDom);
		$("a[name='symbol']").map(function (index, elem) {
			var text = $(this).data("text");
			$(elem).linkbutton({
				size: "small",
				onClick: function () {
					addSymbol(text);
				},
				text: text,
			});
		});
	}
	var e = $("#multiVSTable").datagrid("getColumnOption", field);
	if (vsItem.select) {
		var optData = [];
		vsItem.options.map(function (item) {
			optData.push({ item: item });
		});
		e.editor = {
			type: "combobox",
			options: {
				valueField: "item",
				textField: "item",
				data: optData,
			},
		};
	} else {
		e.editor = {
			type: "text",
			options: {
				required: true,
			},
		};
	}
	$("#multiVSTable").datagrid("editCell", {
		index: index,
		field: [field] || [],
	});
	var ed = $("#multiVSTable").datagrid("getEditor", {
		index: index,
		field: field,
	}); // 获取编辑器
	curEditorTarget = ed.target;
	$(ed.target).focus().bind("keyup", function (e) {
		if (13 == e.keyCode) e.keyCode = enterkeyCode;
		if ([13, 37, 38, 39, 40].indexOf(e.keyCode) > -1) {
			forwardMultiTableCell(index, field, e.keyCode);
			return;
		}
	}).bind("blur", function (e) {
		endEditMultiTableCell(2);
	});
	if (vsItem.select) {
		$(ed.target).combobox("textbox").bind("focus", function () {
			$(ed.target).combobox("showPanel");
			$(ed.target).combobox("textbox").bind("keyup", function (e) {
				if (13 == e.keyCode) {
					keyCode = keyCode || enterkeyCode;
					if ([13, 37, 38, 39, 40].indexOf(keyCode) > -1) {
						forwardMultiTableCell(index, field, keyCode);
						return;
					}
				}
			});
		}).focus();
	}
	if (vsItem.symbol) {
		$(ed.target).tooltip({
			position: "top",
			hideEvent: "none",
			deltaY: 10,
			backgroundColor: "rgba(255,255,255,0.8)",
			content: function () {
				return $("#" + tipId);
			},
			onShow: function (e) {
				if (e) {
					$(this).tooltip("tip").css({
						left: e.clientX - e.offsetX - ($("#" + tipId).width() + 18 - e.target.clientWidth) / 2 + "px",
						top: e.clientY - e.offsetY - 35 + "px",
						background: '#fff',
						border: '1px solid #cccccc',
					});
				}
			},
		});
		$HUI.tooltip(ed.target).show();
		$(curEditorTarget).tooltip("tip").css({
			background: '#fff',
			border: '1px solid #cccccc',
		});
	}
}
function editTableCell(index, field, keyCode){
	var $td=$('tr[datagrid-row-index="'+index+'"]>td[field="'+field+'"]');
	var bgColor=$td.css('backgroundColor');
	if ('rgb(228, 228, 228)'==bgColor) {
		if (keyCode) {
			forwardTableCell(index, field, keyCode);
		}
		return;
	}
	var rows=$('#multiVSTable').datagrid('getRows'),row=rows[index];
	var saveRes=endEditTableCell();
	if (!saveRes) {
		colIndex=originColIndex;
		return;
	}
	if (subScreen) {
		var episodeId=patientList[index].episodeID;
		var curDay=$('#currentDay').datebox('getValue');
		if ((secondScreen.EpisodeID!=episodeId)||(secondScreen.Date!=curDay)) {
			secondScreen.EpisodeID=episodeId;
			secondScreen.Date=curDay;
			window.parent.websys_emit("onOpenTempPreview",{EpisodeID:episodeId,MWToken:websys_getMWToken(),Date:curDay});
		}
	}
	var vsItem=singleConfigObj[field];
	var tipId=vsItem.code+"Tip";
	if (vsItem.symbol&&!$("#"+tipId).length) {
		var tipDom='<div id="'+tipId+'">';
		vsItem.symbol.map(function(e) {
			tipDom+='<a href="#" name="symbol" class="easyui-linkbutton" data-options="plain:true" data-text="'+e+'"></a>';
		})
		tipDom+='</div>';
		$("#toolTips").append(tipDom);
		$("a[name='symbol']").map(function(index,elem) {
			var text=$(this).data('text');
      		$(elem).linkbutton({size:'small',onClick:function () {addSymbol(text);},text:text});
		});
	}
	var e = $('#multiVSTable').datagrid('getColumnOption', field);
	if (vsItem.select) {
		var optData=[];
		vsItem.options.map(function(item) {
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
	$('#multiVSTable').datagrid('editCell', {
		index:index,
		field:[field]||[]
	});
	var ed = $('#multiVSTable').datagrid("getEditor", {index: index, field: field});// 获取编辑器
	curEditorTarget=ed.target;
	$(ed.target).focus().bind('keyup',function(e) {
		console.log(e.keyCode);
		if (13==e.keyCode) e.keyCode=enterkeyCode;
		if ([13,37,38,39,40].indexOf(e.keyCode)>-1) {
			forwardTableCell(index, field, e.keyCode);
			return;
		}
	}).bind('blur', function(e) {
		endEditTableCell(2);
	});
	if (vsItem.select) {
		$(ed.target).combobox('textbox').bind('focus',function(){
			$(ed.target).combobox('showPanel')
			$(ed.target).combobox('textbox').bind("keyup",function(e) {
				if (13==e.keyCode) {
					keyCode=keyCode || enterkeyCode;
					if ([13,37,38,39,40].indexOf(keyCode)>-1) {
						forwardTableCell(index, field, keyCode);
						return;
					}
				}
			})
		}).focus();
	};
	$(".tooltip").hide();
	if (vsItem.symbol) {
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
				if (e) {
					$(this).tooltip("tip").css({
						left: e.clientX - e.offsetX - ($("#" + tipId).width() + 18 - e.target.clientWidth) / 2 + "px",
						top: e.clientY - e.offsetY - 35 + "px",
						background: '#fff',
						border: '1px solid #cccccc',
					});
				}
	    	}
		});
		$HUI.tooltip(ed.target).show();
		$(curEditorTarget).tooltip("tip").css({
			background: '#fff',
			border: '1px solid #cccccc',
		});
	}
}
function changeEnterDirect(){
	enterkeyCode=$('#enterDirect').combobox('getValue') || enterkeyCode;
	enterkeyCode=parseInt(enterkeyCode);
	localStorage.setItem("enterkeyCode"+session['LOGON.USERID'],enterkeyCode);
}
function forwardTableCell(index, field, keyCode){
	originColIndex=colIndex;
	var rows=$('#multiVSTable').datagrid('getRows'),row=rows[index];
	var colspan;
	switch(keyCode){
	  	case 38: //上
			if (0==index) {
				index=rows.length-1;
				if (0==colIndex) {
					colIndex=colCodes.length-1;
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
				if ((colCodes.length-1)==colIndex) {
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
				colIndex=colCodes.length-1;
			} else {
				colIndex--;
			}
			break;
	  	case 39: //右
			if (colIndex==(colCodes.length-1)) {
				colIndex=0;
				if (index==(rows.length-1)) {
					index=0;
				} else {
					index++;
				}
			} else {
				colIndex++;
			}
			break;
	  	default:
			return;
	}
	field=colCodes[colIndex];
	editTableCell(index, field, keyCode)
}
function endEditTableCell(flag){
	if (1==flag) {
		$(".tooltip").hide();
	}
	var rows=$('#multiVSTable').datagrid('getRows');
	// 结束编辑
	for (var i = 0, len = rows.length; i < len; i++) {
		e=rows[i];
		var ed = $('#multiVSTable').datagrid("getEditors",i)[0];// 获取编辑器
		if (ed) {
			var curDay=$('#currentDay').datebox('getValue');
			e=singleConfigObj[ed.field];
			eT=singleConfigObj[ed.field+'_Title'];
			if (e.yestDesc||(eT&&eT.yestDesc)) {
				var newDay=Date.parse(standardizeDate(curDay))-24 * 3600 * 1000;
				curDay=formatDate(new Date(newDay));
			}
			if (e.select) {
				var value=$(ed.target).combobox('getValue');
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
						} else if (value.length!=(parseFloat(value)).toString().length) { // 需求号：2627879
							$.messager.popover({msg: $g('数值小数点后为0不能保存！'),type:'alert'});
							return false;
						} else {
							value=parseFloat(value);
						}
						if (value > e.errorValueHightFrom || value < e.errorValueLowTo) {
							$(ed.target).addClass('error');
							$.messager.popover({msg: $g('填写的值超出正确范围！'),type:'alert'});
							return false;
						}
					}
					if (value == parseFloat(value)) {
						if (value < e.normalValueRangFrom || value > e.normalValueRangTo) {
							$(ed.target).addClass('warning');
						}
					}
				}
			}
			var eTitle=singleConfigObj[e.code+"_Title"];
			if (eTitle&&(''!==value)) {
				if (e.yestDesc&&!patientList[i][e.code+"_Title_yest"]) {
					$.messager.popover({msg: $g('录入空白栏数据前请先录入空白栏标题！'),type:'alert'});
					return false;
				}
				if (!e.yestDesc&&!patientList[i][e.code+"_Title"]) {
					$.messager.popover({msg: $g('录入空白栏数据前请先录入空白栏标题！'),type:'alert'});
					return false;
				}
			}
			console.log(rows[i]);
			var res=$cm({
				ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
				MethodName: "SaveObsDataByDay",
				dataType: "text",
				episodeID:rows[i].episodeID,
				modifyData:JSON.stringify([{
					code:e.code,
					value:value,
					time:$('#timePoint').timespinner('getValue')
				}]),
				userID:session["LOGON.USERID"],
				date:curDay,
				userLocID:session["LOGON.CTLOCID"],
				wardID:session['LOGON.WARDID']
			}, false);
			if ('-1000'==res) {
				$('#multiVSTable').datagrid('endEdit', i);
				applyAuthority(rows[i]);
			} else if (0==parseInt(res)) {
				if (res.toString().indexOf('^')>-1) {
					$.messager.popover({msg: $g(res.split('^')[1]),type:'alert'});
				}else if (1==flag) {
					$.messager.popover({msg: $g('数据保存成功'),type:'success'});
				}
				if(subScreen) {
					window.parent.websys_emit("vitalSignChange",{});
				}
				// 将空白栏标题的修改值保存到patientList里，以方便校验空白栏的录入
				if (e.code.indexOf('_Title')>-1) {
					if (e.yestDesc) {
						patientList[i][e.code+"_yest"]=value;
					} else {
						patientList[i][e.code]=value;
					}
				}
			} else {
				$.messager.popover({msg: res,type:'alert'});
				return false;
			}
			if (2!=flag) {
				$('#multiVSTable').datagrid('endEdit', i);
      		}
			// 更新控制体征项录入频次的数据
			if ((singleConfigObj[e.code].formulaControl=="Y")&&!$("#needMeasure").checkbox('getValue')) {
				updateFormulaControlData(i,curDay,e.code);
			}
			updateDomSize();
			return true;
		}
	}
	return true;
}
function applyAuthority(patientInfo) {
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
function getSingleConfig() {
	$cm({
		ClassName: 'Nur.NIS.Service.VitalSign.Temperature',
		MethodName: 'GetAllTempConfig',
		locID: session['LOGON.CTLOCID'],
		time: "",
		wardId: session['LOGON.WARDID'],
		// ifBaby:ifBaby
	}, function (data) {
		singleConfig=data.SingleConfig;
		if (!singleConfigObj) {
			singleConfigObj={};
			$("#vsItems tr:eq(1) td").empty();
			var len=0;
			for (var i = 0; i < singleConfig.length; i++) {
				var e=singleConfig[i];
				// 去除成人婴儿体征不匹配的项
				if ((1!=ifBaby)&&(1==e.flag)) {
					singleConfig.splice(i,1)
					i--;
					continue;
				}
				if ((1==ifBaby)&&('0'===e.flag)) {
					singleConfig.splice(i,1)
					i--;
					continue;
				}
				e.select=JSON.parse(e.select);
				e.blank=JSON.parse(e.blank);
				e.validate=JSON.parse(e.validate);
				if (e.errorValueHightFrom) e.errorValueHightFrom=parseFloat(e.errorValueHightFrom);
				if (e.errorValueLowTo) e.errorValueLowTo=parseFloat(e.errorValueLowTo);
				if (e.normalValueRangFrom) e.normalValueRangFrom=parseFloat(e.normalValueRangFrom);
				if (e.normalValueRangTo) e.normalValueRangTo=parseFloat(e.normalValueRangTo);
				singleConfigObj[e.code]=e;
				len=Math.max(len,e.desc.length);
				var item='<input class="hisui-checkbox vsItem" type="checkbox"  data-id="'+e.code+'"  data-options="onCheckChange:vsItemChange" label="'+e.desc+'" id="'+e.code+'">';
				$("#vsItems tr:eq(1) td").append(item);
			$("#vsItems tr:eq(1) td input:eq(-1)").checkbox({
				label: e.yestDesc||e.desc,
				value: e.code,
				// checked: i<3?true:false
				checked: data.DefaultCheck&&(data.DefaultCheck.indexOf(e.code)>-1)
			});
			}
			$("#vsItems label.vsItem").css({
				'min-width':len*14+'px',
				// display: 'inline-block'
			});
		}
		if ($("#switch").switchbox('getValue')) {
			getPatientsTempDataByDay();
		} else {
			getPatientsTempDataByTime();
		}
  	});
}
function addSymbol(d){
	$(curEditorTarget).val($(curEditorTarget).val()+d)
}
function InitTip(){
	var _content="<p>"+$g("红色框：")+$g("非有效数据")+"</p>";
	_content+="<p>"+$g("黄色框：")+$g("非正常数据")+"</p>";
	$("#vsReminder_tip").popover({
		trigger:'hover',
		content:_content,
		style:'inverse'
	});
	_content="<p>"+$g("点击带入时间点并自动查询。")+"</p>";
	$("#timePointTip").popover({
		trigger:'hover',
		content:_content,
		style:'inverse'
	});
}
// 设置日期选择框禁用值
function setDateboxOption() {
	// var now = new Date();
	// var currentDay=$("#currentDay").datebox('getValue'),endDate=$("#endDate").datebox('getValue');
	// var startOpt=$("#currentDay").datebox('options'),endOpt=$("#endDate").datebox('options');
	// if (!currentDay||!endDate) return;
	// startOpt.maxDate = endDate;
	// endOpt.minDate = currentDay;
	// endOpt.maxDate = endOpt.formatter(now);
}
// 标准化日期
function standardizeDate(day) {
	var y=dateformat.indexOf('YYYY');
	var m=dateformat.indexOf('MM');
	var d=dateformat.indexOf('DD');
	var str=day.slice(y,y+4)+'/'+day.slice(m,m+2)+'/'+day.slice(d,d+2);
	return str;
}
// 格式化日期
function formattingDate(day) {
	var s=dateformat||'YYYY-MM-DD';
	var y=s.indexOf('YYYY');
	var m=s.indexOf('MM');
	var d=s.indexOf('DD');
	s=s.replace('YYYY',day.substr(y, 4));
	s=s.replace('MM',day.substr(m, 2));
	s=s.replace('DD',day.substr(d, 2));
	return s;
}
window.addEventListener("click",function() {
  	$('#mm').hide();
})
function updateDomSize() {
	var innerHeight=window.innerHeight;
	$('#patientList').panel('resize', {
	  	height:innerHeight-93
	});
	$('#multiVSPanel').panel('resize', {
	  	height:innerHeight-8
	});
	$('#multiVSTable').datagrid('resize',{
	    height:innerHeight-$('#vsItems').height()-($("#switch").switchbox('getValue')?109:148)
	})
	var $div=$('#multiVSTable').prev('.datagrid-view2');
	$div.find('.datagrid-body td.warning').map(function (i,obj) {
		var field=$(obj).attr('field');
		var width=$div.find('.datagrid-header td[field="'+field+'"]').width();
		$(obj).children('div').width(width-19);
	})
}
window.addEventListener("resize",updateDomSize);