/**
* @author wujiang
*/
if (!Array.prototype.includes) {
    Array.prototype.includes = function(elem){
        if (this.indexOf(elem)<0) {
            return false;
        } else {
            return true;
        }
    }
}
if (!String.prototype.includes) {
    String.prototype.includes = function(elem){
        if (this.indexOf(elem)<0) {
            return false;
        } else {
            return true;
        }
    }
}
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
				if (!param.field.includes(fields[i])){
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
		$('#bloodGlucose').datagrid('editCell', {
			index:index,
			field:oldFields||[]
		});
	};
})();
var frm = dhcsys_getmenuform();
if (frm) {
	patNode={
		episodeID:frm.EpisodeID.value,
		patientID:frm.PatientID.value
	}
	console.log(patNode);
}
var hospComp,hospID,wardsData=[],docAdvicesObj={};
var patNode,ctcRecordObj={},subRecordObj={},updateADRsFlag=true,treeTimer,backupIds=[],curModelType,fixRowNum,saveFlag=true;
var bgConfig={},bgConfigData=[];//血糖配置信息
var adrsItemId;//不良反应项id
var columns=[],timeouter,bgData=[];
var warnCondition=[],filterIndex=[];//预警条件
var measures=[];//措施
var retestObj={};//修改血糖值或复测血糖值信息
var page=1, pageSize=20;
var myChart;
$('#bloodGlucose').datagrid({
	singleSelect: true,
	onClickRow: function (rowIndex, rowData) {
		$(this).datagrid('unselectRow', rowIndex);
	},
	// width:800,
  // height:500
});
// $('#bloodGlucose').datagrid('freezeRow',0).datagrid('freezeRow',1).datagrid('freezeRow',2).datagrid('freezeRow',3).datagrid('freezeRow',4);
var unfoldFlag=true;//评估项树展开标识
$(function() {
	hospComp = GenHospComp("Nur_IP_BGTime",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		hospID=d.HOSPRowId;
		docAdvicesObj={};
		init();
	}
	init();
});
// 初始化
function init() {
	$('#endDate').datebox('setValue', formatDate(new Date()));
	$('#startDate').datebox('setValue', dateCalculate(new Date(), -6));
	$("#redkw").keywords({
    singleSelect:true,
    labelCls:'red',
    items:[
        {text:'本人',id:'1',selected:true},
        {text:'本科',id:'2'},
        {text:'内分泌虚拟病房',id:'3'}
    ],
    onClick:function(v){
    	getBGRecordByDays();
    },
    onUnselect:function(v){console.log("你选择->");console.dir(v);},
    onSelect:function(v){console.log("你取消选择->");console.dir(v);}
	});
	// $("#redkw").keywords('select',1);
	setDateboxOption();
	// 更新dom元素的大小
	updateDomSize();
	var count=0;
	// 获取会诊申请时效和默认血糖采集时间列
  $cm({
    ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
    MethodName: 'GetApplyHourAndTimeShow',
    dataType: "text",
    hospDR: hospID
  }, function(res) {
  	if (res) {
  		res=JSON.parse(res);
			// $("#applyHour").numberbox('setValue',res.applyHour);
			if ('Y'==res.timeShow) {
				$("#switch").switchbox('setValue',false);
			} else {
				$("#switch").switchbox('setValue',true);
			}
  	}
  	count++;
  });
	// 获取血糖采集时间配置
  $cm({
      ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
      QueryName: 'GetBGConfig',
      rows: 999999999999999,
      random: "Y",
      hospDR: hospID
  }, function (data) {
  	data=data.rows;
  	console.log(data);
  	bgConfigData=data;
  	data.map(function(e) {
  		bgConfig[e.VSId]=e;
  		bgConfig[e.VSCode]=e.VSId;
  		var item='<td class="r-label"><input class="hisui-checkbox bgItem" type="checkbox"  data-id="'+e.id+'"  data-options="onCheckChange:bgCfgChange" label="'+e.VSDesc+'" id="'+e.VSCode+'"></td>';
  		$("#bgConfig tr").append(item);
      $("#bgConfig tr td:eq(-1) input").checkbox({
        label: e.VSDesc,
        value: e.id,
        checked: true
      });
  	})
  	count++;
  });
	// 获取血糖预警配置
  $cm({
      ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
      QueryName: 'GetBGWarn',
      rows: 999999999999999,
      hospDR: hospID
  }, function (data) {
  	data=data.rows;
  	console.log(data);
  	warnCondition=data.filter(function(e) {
  		return 'W'==e.type; //取警示的数据
  	});
  	data.map(function(e,i) {
  		if ('W'==e.type) { //取警示的数据
	  		var item='<span class="severity" onclick="toggleStatus(this,'+i+');" style="color: '+e.color+';border: 1px solid '+e.color+';">'+e.name+'</span>';
	  		$("#bgWarn tr td:eq(0)").append(item);
	  		var detail='<p><i class="dot" style="background: '+e.color+';"></i><span>'+e.variableDesc+e.docMeasure+'</span></p>';
	  		$("#bgWarn .helpDetail").append(detail);
  		}
  	});
  	count++;
  });
	// 获取病区列表
  $cm({
      ClassName: 'Nur.NIS.Service.Base.Ward',
      QueryName: 'GetallWardNew',
      rows: 999999999999999,
      bizTable: "Nur_IP_WardProGroup",
      hospid: hospID
  }, function (data) {
  	data=data.rows;
  	$('#ward').combobox('loadData',data);
  	count++;
  });
	var timer = setInterval(function(){
		if(count>3) {
			clearInterval(timer);
	  	getBGRecordByDays();
		}
	},30);
}
function bgCfgChange(e,v) {
	console.log(arguments);
	if (v) {
  	bgConfigData.map(function(e) {
  		v=v && $("#"+e.VSCode).checkbox('getValue');
  	})
	}
	if (saveFlag) {
		getBGRecordByDays();
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
		bgConfigData.map(function(e) {
			$("#"+e.VSCode).checkbox('setValue',v);
		})
		timeouter=setTimeout(function(){
			saveFlag=true;
		},300);
		getBGRecordByDays();
	}
}
// 设置日期选择框禁用值
function setDateboxOption() {
	var now = new Date();
	var startDate=$("#startDate").datebox('getValue'),endDate=$("#endDate").datebox('getValue');
	var startOpt=$("#startDate").datebox('options'),endOpt=$("#endDate").datebox('options');
	if (!startDate||!endDate) return;
	startOpt.maxDate = endDate;
	endOpt.minDate = startDate;
	endOpt.maxDate = endOpt.formatter(now);
}
// 切换选中的状态
function toggleStatus(obj,i) {
	var pbgColor=$(obj).css('background-color'),cbgColor=$(obj).css('color');
	$(obj).css({
		background:cbgColor,
		color:pbgColor
	});
	if ('rgb(255, 255, 255)'==pbgColor) {
		filterIndex.push(i);
	} else {
		filterIndex.splice(filterIndex.indexOf(i),1);
	}
	getBGRecordByDays();
}
// 获取某些天的血糖记录
function getBGRecordByDays() {
	var type=$("#redkw").keywords('getSelected')[0];
	console.log(type);
	var startDate=$("#startDate").datebox('getValue'),endDate=$("#endDate").datebox('getValue');
	var obsDrs=[];
	var keys=Object.keys(bgConfig);
	keys.map(function(e) {
		var v=$("#"+bgConfig[e].VSCode).checkbox('getValue');
		if (v) obsDrs.push(e);
	})
	var mediNoKey=$("#medicareNo").val();
	var patNameKey=$("#patName").val();
	var bedCodeKey=$("#bedCode").val();
	var bgLow=$("#bgLow").val();
	var bgHigh=$("#bgHigh").val();
	var wardKey=$('#ward').combobox('getValue');
	saveFlag=false;
	var warnCond=[];
	for (var j = 0; j < filterIndex.length; j++) {
		var i=filterIndex[j];
		var condition='(M'+warnCondition[i].condition+')';
		condition=condition.replace(/\|\|/g,')||(M').replace(/\&\&/g,')&&(M');
		warnCond.push({
			items:warnCondition[i].relatedBGItems.split(','),
			condition:condition,
		});
	}
// relatedBGItems: "102,101,105"
// condition: ">=16.7||<=3.9"
	timeouter=setTimeout(function(){
		saveFlag=true;
	},800);
  $cm({
    ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseV2',
    MethodName: 'getBGRecordByConditions',
    Type: type.id,
    startDate: startDate,
    endDate: endDate,
    ObsDrs: JSON.stringify(obsDrs),
    mediNoKey: mediNoKey,
    patNameKey: patNameKey,
    bedCodeKey: bedCodeKey,
    wardKey: wardKey,
    hospDR: hospID,
    page: page,
    pageSize: pageSize,
    bgLow: bgLow,
    bgHigh: bgHigh,
    warnCond: JSON.stringify(warnCond)
  }, function (res) {
  	var data=res.rows;
		if (filterIndex.length) { //过滤
			for (var k = 0; k < data.length; k++) {
				var d=data[k],flag=true;
				for (var m = 0; m < bgConfigData.length; m++) {
					var vscode=bgConfigData[m].VSCode,vsId=bgConfigData[m].VSId;
					var value=d[vscode];
					if ((''===value)||('undefined'==typeof value)) continue;
					var values=value.toString().split('/');
					for (var n = 0; n < values.length; n++) {
						value=values[n];
						for (var j = 0; j < filterIndex.length; j++) {
							var i=filterIndex[j];
							if (!warnCondition[i].relatedBGItems.split(',').includes(vsId)) continue;
							var condition=value+warnCondition[i].condition;
							condition=condition.replace(/\|\|/g,'||'+value).replace(/\&\&/g,'&&'+value)
							if (!eval(condition)) continue;
							flag=false;
							break;
						}
					}
				}
				if (flag) {
					data.splice(k,1);
					k--;
				}
			}
		}
  	bgData=JSON.parse(JSON.stringify(data));
  	var columnWidth=130;
  	columns=[
	  	{field: "bedCode", title:'床号'},
	  	{field: "medicareNo", title:'病案号'},
	  	{field: "name", title:'姓名'},
	  	{field: "height", title:'身高'},
	  	{field: "weight", title:'体重'},
	  	{field: "bmi", title:'BMI'},
	  	{field: "diagnosis", title:'诊断'},
	  	{field: "date", title:'测量日期'}
  	];
  	var switcher=$("#switch").switchbox('getValue');
  	bgConfigData.map(function(e) {
  		var v=$("#"+e.VSCode).checkbox('getValue');
			if (v) {
				// if (!switcher) {
				// 	columns.push({
				// 		field: e.VSCode+"_Time",title:'时间'
				// 	});
				// }
				var title=e.VSDesc;
				// if (e.startTime) {
				// 	title+='<br>'+e.startTime+'~'+e.endTime;
				// }
				columns.push({
					field: e.VSCode,
					title:title,
					editor:{type:'text'},
					styler:function(value,row,index){
						if ((''===value)||('undefined'==typeof value)) return;
						// if (value.toString().includes('/')) return;
						if (value.toString().includes('/')) value=parseFloat(value);
						var vsId=bgConfig[e.VSCode];
						if (filterIndex.length) {
							for (var j = 0; j < filterIndex.length; j++) {
								var i=filterIndex[j];
								// if ((''===value)||('undefined'==typeof value)) continue;
								if (!warnCondition[i].relatedBGItems.split(',').includes(vsId)) continue;
								var condition=value+warnCondition[i].condition;
								condition=condition.replace(/\|\|/g,'||'+value).replace(/\&\&/g,'&&'+value)
								if (!eval(condition)) continue;
								return 'color:'+warnCondition[i].color+';';
							}
							// return 'color:transparent;';
						} else {
							for (var i = 0; i < warnCondition.length; i++) {
								// if ((''===value)||('undefined'==typeof value)) continue;
								if (!warnCondition[i].relatedBGItems.split(',').includes(vsId)) continue;
								var condition=value+warnCondition[i].condition;
								condition=condition.replace(/\|\|/g,'||'+value).replace(/\&\&/g,'&&'+value)
								if (!eval(condition)) continue;
								return 'color:'+warnCondition[i].color+';';
							}
						}
					},
					formatter:function(value, row, index){
						if ((''===value)||('undefined'==typeof value)) return value;
						var vsId=bgConfig[e.VSCode],vsNote=row[e.VSCode+'_Note'];
						if (value.toString().includes('/')) {
							var values=value.toString().split('/');
							var string=""
							for (var j = 0; j < values.length; j++) {
								var value=values[j];
								if (('undefined'==typeof value)||(''===value)) continue;
								if (j>0) string += '/';
								var flag=true;
								for (var i = 0; i < warnCondition.length; i++) {
									if (!warnCondition[i].relatedBGItems.split(',').includes(vsId)) continue;
									var condition=value+warnCondition[i].condition;
									condition=condition.replace(/\|\|/g,'||'+value).replace(/\&\&/g,'&&'+value)
									if (!eval(condition)) continue;
									string += '<span style="color:'+warnCondition[i].color+';">'+value+'</span>';
									flag=false;
								}
								if (flag) string += value;
							}
							// if (vsNote&&vsNote.replace(/\//g,'')) return string + '<span class="icon icon-ok">&nbsp;</span>';
							return string;
						} else {
							for (var i = 0; i < warnCondition.length; i++) {
								if (!warnCondition[i].relatedBGItems.split(',').includes(vsId)) continue;
								var condition=value+warnCondition[i].condition;
								condition=condition.replace(/\|\|/g,'||'+value).replace(/\&\&/g,'&&'+value)
								if (!eval(condition)) continue;
								if (('Y'==warnCondition[i].retestFlag)&&!value.toString().includes('/')) {
									// var str = '<a href="javascript:void(0);" name="retestBG" data-id="'+row[e.VSCode+'_Id']+'" data-vscode="'+e.VSCode+'" data-index="'+i+'" data-rowindex="'+index+'" class="easyui-linkbutton" ></a>'
									// if (vsNote) str += '<span class="icon icon-ok">&nbsp;</span>';
									// return value+str;
									return value;
								}
							}
							// if (vsNote) return value + '<span class="icon icon-ok">&nbsp;</span>';
							return value;
						}
					}
				});
			}
  	})
  	columns.push({field: 'ltma',title:'降糖医嘱（长期）'});
  	columns.push({field: 'tmo',title:'降糖医嘱（临时）'});
  	columns.push({field: 'operate',title:'操作',formatter:function(value, row, index) {
  		return '<span class="icon icon-blue-edit" title="开立医嘱" onClick="makeAnOrder('+row.episodeID+');">&nbsp;</span> <span class="icon icon-paper-pen" title="会诊申请" onClick="consultApply('+row.episodeID+');">&nbsp;</span>';
  	}});
  	
		$('#bloodGlucose').datagrid({
			// frozenColumns:[[
			// 	{field:'bedCode',title:'床号',width:60},
			// 	{field:'name',title:'姓名',width:90}
			// ]],
			pagination:true,
			columns:[columns],
			data:res,
      pageSize: pageSize, 
			onLoadSuccess:function(data){
				$("a[name='retestBG']").map(function(index,elem) {
					var id=$(this).data('id'),vscode=$(this).data('vscode'),index=$(this).data('index'),rowindex=$(this).data('rowindex');
	        $(elem).linkbutton({plain:true,size:'small',onClick:retestBG(id,vscode,index,rowindex),iconCls:'icon-down-arrow-box'});
				});
				var $td=$("#bloodGlucose").prev().find('.datagrid-body>table tr>td');
				$td.mouseenter(function(event) {
					var field=$(this).attr('field');
					if (!$("#"+field).checkbox('getValue')) return;
					var rowIndex=$(this).parent().attr('datagrid-row-index');
					var row=bgData[rowIndex],value=row[field];
					if ((''===value)||('undefined'==typeof value)) return;
					var values=value.toString().split('/');
					var content="";
					for (var i = 0; i < values.length; i++) {
						if (i>0) content+='<br>';
						content+="录入时间："+row.date+'<br>';
						content+="采集时间："+row[field+'_Time'].split('/')[i]+'<br>';
						content+="血糖值："+values[i]+'mmol/L<br>';
						content+="录入人："+row[field+'_Nurse'].split('/')[i]+'<br>';
						content+="处理措施："+(row[field+'_Note']||'').split('/')[i]+'<br>';
					}
					var placement="bottom";
					if (rowIndex>8) placement="top";
					$(this).popover({trigger:'manual',placement:placement,content:content}).popover('show');
				}).mouseleave(function() {
					if ($(this)&&$(this).popover) {
						try {
							$(this).popover('hide');
						}catch(e){}
					}
				});
			}
		}).datagrid("getPager").pagination({
	    onSelectPage:function(p,size){
				page=p;
				pageSize=size;
				if (saveFlag) {
					console.log(p,size);
					getBGRecordByDays();
				}
	    },
	    onRefresh:function(p,size){
	    	console.log(p,size);
				page=p;
				pageSize=size;
				getBGRecordByDays();
	    },
	    onChangePageSize:function(size){
	    	console.log(size);
				page=1;
				pageSize=size;
				getBGRecordByDays();
	    }
		}).pagination('select', page);;
  });
}
function retestBG(tmpId,tmpCode,tmpIndex,tmpRowIndex) {
	var id=tmpId,vscode=tmpCode,index=tmpIndex,rowindex=tmpRowIndex;
	return function() {
		showRetestModal(id,vscode,index,rowindex,'Y');
	}
}
function showRetestModal(id,vscode,i,rowindex,verifyFlag) {
	console.log(arguments);
	console.log(bgData);
	var spliter=String.fromCharCode(13);
	measures=warnCondition[i].nurseMeasure.split(spliter);
	if (measures.length) {
		$("#measure").empty();
  	measures.map(function(e) {
  		var item='<input class="hisui-checkbox measureItem" type="checkbox" label="'+e+'" id="'+e+'">';
  		$("#measure").append(item);
      $("#measure input:eq(-1)").checkbox({
        label: e,
        value: e,
        checked: false
      });
  	})
	}
	retestObj={
		retestFlag:warnCondition[i].retestFlag,
		itemDr:bgConfig[vscode],
		episodeID:parseInt(id),
		verify:verifyFlag,
		date:bgData[rowindex-1].date,
	}
	console.log(retestObj);
	openRetestModal("复测血糖");
}
// 开立医嘱
function makeAnOrder(episodeID) {
	console.log(episodeID);
  var innerWidth=window.innerWidth-50;
  var innerHeight=window.innerHeight-50;
  $('#retestModal').dialog({
    width: innerWidth,
    height: innerHeight,
  }).dialog("open");
	$HUI.dialog('#retestModal').setTitle('开立医嘱');
	$("#retestModal iframe").attr('src','oeorder.oplistcustom.new.csp?EpisodeID='+episodeID+'&mradm='+episodeID+'&forceRefresh=true');
}
// 会诊申请
function consultApply(episodeID) {
	console.log(episodeID);
  var innerWidth=window.innerWidth-50;
  var innerHeight=window.innerHeight-50;
  $('#retestModal').dialog({
    width: innerWidth,
    height: innerHeight,
  }).dialog("open");
	$HUI.dialog('#retestModal').setTitle('会诊申请');
	$("#retestModal iframe").attr('src','dhcem.consultmain.csp?EpisodeID='+episodeID+'&mradm='+episodeID+'&forceRefresh=true');
}
// 模态框关闭后事件
$("#retestModal").dialog({
  onClose: getBGRecordByDays
});
function openRetestModal(title) {
  var innerWidth=window.innerWidth-50;
  var innerHeight=window.innerHeight-50;
  $('#retestModal').dialog({
    width: innerWidth,
    height: innerHeight,
  }).dialog("open");
	$HUI.dialog('#retestModal').setTitle(title||'血糖');
	console.log(retestObj);
	$("#testDate").datebox('setValue', retestObj.date);
	if (retestObj.verify||!retestObj.time) {
		// 复测血糖，设置默认时间和可编辑
		$("#testTime").timespinner('setValue', (new Date()).toTimeString().slice(0, 5));
	}else{
		$("#testTime").timespinner('setValue', retestObj.time);
	}
	$("#bgValue").val(retestObj.value);
	getObsTableData();
}
function updateDomSize() {
		var innerHeight=window.innerHeight;
	  $('#patientList').panel('resize', {
	  	height:innerHeight-93
	  }); 
	  $('#adrsPanel').panel('resize', {
	  	height:innerHeight-11
	  }); 
		$('#evaluateList').datagrid('resize',{
	    height:innerHeight-62
	  })
		$('#bloodGlucose').datagrid('resize',{
	    height:innerHeight-130
	  })
}
window.addEventListener("resize",updateDomSize)