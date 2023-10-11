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
  getEditingRowIndexs: function(jq) {
    var rows = $.data(jq[0], "datagrid").panel.find('.datagrid-row-editing');
    var indexs = [];
    rows.each(function(i, row) {
      var index = row.sectionRowIndex;
      if (indexs.indexOf(index) == -1) {
          indexs.push(index);
      }
    });
    return indexs;
  }
});
// -----------------------------------------------------
var hospID,wardsData=[],docAdvicesObj={},diagnoseObj={};
var editBGIndex,bgTableData={"total":0,"rows":[]};
var rtTableData={"total":0,"rows":[]};
var dgTableData={"total":0,"rows":[]};
var diagTableData={"total":0,"rows":[]};
var vitalSignList=[],oriVitalSignList=[];
var wardDescObj={},daObj={},dgObj={};
var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串  
var isOpera = userAgent.indexOf("Opera") > -1; //判断是否Opera浏览器  
var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera || userAgent.indexOf("rv:11") > -1; //判断是否IE浏览器 
if ('undefined'!=typeof cefbound) isIE = true; //医为浏览器
if ('undefined'==typeof HISUIStyleCode) {
	var HISUIStyleCode="blue";
}
var selected;
var arr = []; 
$(function() {
	hospComp = GenHospComp("Nur_IP_BGTime",session["LOGON.USERID"]+'^'+session["LOGON.GROUPID"]+'^'+session["LOGON.CTLOCID"]+'^'+session["LOGON.HOSPID"]);
	hospID=hospComp.getValue();
	hospComp.options().onSelect = function(i,d){
		hospID=d.HOSPRowId;
		docAdvicesObj={};
		diagnoseObj={};
		init();
	}
	init();
	$("#color").minicolors({
			control: 'hue',
			defaultValue: '',
			inline: false,
			letterCase: 'uppercase',
			// opacity: $(this).attr('data-opacity'),
			position: 'bottom left',
			change: function(hex, opacity) {
					if (!hex)
							return;
					if (opacity)
							hex += ', ' + opacity;
					try {
							console.log(hex);
					} catch (e) {
					}
			},
			theme: 'bootstrap'
	});
	if ('lite'==HISUIStyleCode) { //极简
		$('.eduExeStyle').append('span.icon.icon-help{font-size: 0;}');
	}
})
function init() {
	getBGTableData();
	getRbgdTableData();
	if (!IsStandardEdition) {
		getallWardNew();
		getDiagTableData();
		getBWTableData();
	}
	// 获取会诊申请时效和默认血糖采集时间列
  $cm({
    ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
    MethodName: 'GetApplyHourAndTimeShow',
    dataType: "text",
    hospDR: hospID
  }, function(res) {
  	if (res) {
  		res=JSON.parse(res);
			$("#applyHour").numberbox('setValue',res.applyHour);
			$("#timeShow").combobox('setValue',res.timeShow);
			$("#remarkShow").combobox('setValue',res.remarkShow);
  	}
  });
	getDgTableData();
	$('#color').click(function(e) {
	  e.stopPropagation();
		// selected=$(this)[0];
		$('.jscolor-picker-wrap').css({
			// left: e.pageX,
			// top: Math.min(e.clientY, window.innerHeight - 330) + "px",
			zIndex:$(this).parents('.panel.window').css('zIndex')+1
		}).show();
	});
	loadBasicDict();
}
function loadBasicDict(){
  $cm({
		ClassName: "Nur.NIS.Service.BasicDict.Config",
		QueryName: "GetBasicDict",
		rows: 9999,
		// keyword:$("#values").combobox("getText"),
		hospDR: hospID,
		groupFlag: 1,
	}, function (data) {
		$("#nurseMeasure").combobox({
			'panelHeight':data.rows.length>7?210:'auto',
			'data':data.rows
		});
		$("#docMeasure").combobox({
			'panelHeight':(data.rows.length>7)?210:'auto',
			'data':data.rows
		});
	});
}
function getWardsDesc(wardIDString) {
	if (''==wardIDString) return "";
	var ids=wardIDString.toString().split(','),str="";
	ids.map(function(elem,index) {
		str+=wardDescObj[elem]+",";
	});
	return str.slice(0,-1);
}
function getallWardNew() {
	// 获取病区
    $cm({
        ClassName: 'Nur.NIS.Service.Base.Ward',
        QueryName: 'GetallWardNew',
        desc: '',
        hospid: hospID,
        bizTable: 'Nur_IP_ExchangeItem',
        rows: 10000
    }, function (data) {
        wardList=data.rows;
        wardList.map(function(elem,index) {
        	wardDescObj[elem.wardid]=elem.warddesc;
        });
				$HUI.combobox(".locs",{
					multiple:true,valueField:'wardid', textField:'warddesc',
					data:wardList,
					defaultFilter:4
				});
				getMNTableData();
    });
}
function draw() {
	var w=5; //宽度是2
	var count=0
  var flag=false;
  var pos=[];
  var L=2*63*63;
	for (var x = 0; x < 64; x++) {
  	for (var y = 0; y < 64; y++) {
  		var b=x*x+y*y;
  		if (b) {
  			var alpha=(b+L-Math.pow(63-x,2)-Math.pow(63-y,2))/(2*Math.sqrt(b*L));
  		} else {
  			var alpha=1;
  		}
  		pos.push({
  			x:x,
  			y:y,
  			sort:alpha*Math.sqrt(b),
  		})
  	}
	}
	pos=pos.sort(function(a,b) {
		return a.sort-b.sort
	})
	count=0;
  var L=3*15*15;
  for (var i = 0; i < 16; i++) {
    for (var j = 0; j < 16; j++) {
      for (var k = 0; k < 16; k++) {
    		var b=i*i+j*j+k*k;
    		if (b) {
    			var alpha=(b+L-Math.pow(15-i,2)-Math.pow(15-j,2)-Math.pow(15-k,2))/(2*Math.sqrt(b*L));
    		} else {
    			var alpha=1;
    		}
        arr.push({
    			sort:alpha*Math.sqrt(b),
          // color: 'rgb(' + Math.floor(255 - 16 * i) + ',' + Math.floor(255 - 16 * j) + ',' + Math.floor(255 - 16 * k) + ')'
          color: '#' + hexadecimal(255 - 16 * i) + hexadecimal(255 - 16 * j) + hexadecimal(255 - 16 * k)
        });
        count++;
      }
    }
  }
	arr=arr.sort(function(a,b) {
		return a.sort-b.sort
	})
	pos.map(function(e,i) {
		arr[i].x1=e.x*w;
		arr[i].y1=e.y*w;
		arr[i].x2=e.x*w+w;
		arr[i].y2=e.y*w+w;
    ctx.fillStyle = arr[i].color;
    ctx.fillRect(e.x*w, e.y*w, w, w);
	})
}
// draw();
function hexadecimal(val) {
	val=val.toString(16)
	val='0'+val
	return val.slice(-2);
}
function getBGTableData() {
	// 获取血糖体征项
  vitalSignList=$cm({
      ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
      MethodName: 'GetVSItemByType',
      hospDR: hospID,
      type: "B"
  }, false);
  // console.log(vitalSignList);
  oriVitalSignList=JSON.parse(JSON.stringify(vitalSignList));
	// vitalSignList.map(function(elem,index) {
	// 	vsDescObj[elem.value]=elem.desc;
	// 	vsCodeObj[elem.value]=elem.code;
	// });
	for (var i = 0; i < vitalSignList.length; i++) {
		var elem=vitalSignList[i];
		vsDescObj[elem.value]=elem.desc;
		vsCodeObj[elem.value]=elem.code;
		if ("RBS"==elem.code) {
			vitalSignList.splice(i,1)
			i--;
		}
	}
	// 获取血糖采集时间配置
  $cm({
      ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
      QueryName: 'GetBGConfig',
      rows: 999999999999999,
      hospDR: hospID
  }, function (data) {
  	console.log(data);
    bgTableData=data;
		editBGIndex=undefined;
		$('#bloodGlucose').datagrid({data: bgTableData.rows});
		setTimeout(function() {
			$('#bloodGlucose').datagrid({data: bgTableData.rows});
			$('.evaluate .datagrid-toolbar>table tr>td:eq(2)').html('<div class="helpInfo"> <a href="javascript:void(0);" class="helpFlag"> <span class="icon icon-help">&nbsp;</span> </a> <div class="helpDetail"> <p>说明：</p> <p>定义智能血糖仪采集血糖值时间范围隶属于哪个血糖测量点，即与血糖项目的关系。</p> <p>采集时间范围设置不可重叠。</p> <p>体征项目描述获取【体征配置】中“类型”为“血糖”的项目。</p> </div> </div>');
		}, 100);
  });
	// $("#relatedBGItems").combobox('loadData', vitalSignList);
	$("#relatedBGItems").combobox({
		multiple:true,
		valueField:'value',
		textField:'desc',
		data:oriVitalSignList
	});
	$("#mnRelatedBGItems").combobox({
		multiple:true,
		valueField:'value',
		textField:'desc',
		data:oriVitalSignList
	});
}
function showHelpInfo(e,cls) {
	console.log(arguments);
	if ('helpDiagnose'==cls) {
		$('.'+cls).css({
			left:e.clientX-28+'px',
			top:e.clientY+20+'px'
		}).show();
	} else {
		$('.'+cls).css({
			left:e.clientX-308+'px',
			top:e.clientY+20+'px'
		}).show();
	}
}
function hideHelpInfo(cls) {
	$('.'+cls).hide();
}
function editBGRow(curInd,row) {
	// 当双击另一行时，先保存正在编辑的行
	if ((undefined!=editBGIndex)&&(editBGIndex!=curInd)&&!saveBGRow()) return;
	editBGIndex=curInd;
	$('#bloodGlucose').datagrid('beginEdit', editBGIndex);
  var rowEditors=$('#bloodGlucose').datagrid('getEditors',editBGIndex);
	$(rowEditors[0].target).combobox('loadData', vitalSignList);
	if (row.VSId) {
		$(rowEditors[0].target).combobox('setValue', row.VSId);
	}
	if (1==row.showTime) {
		$(rowEditors[3].target).checkbox('setValue', true);
	}
}
function addBGRow() {
	if ((undefined!=editBGIndex)&&!saveBGRow()) return;
	editBGIndex=$('#bloodGlucose').datagrid('getRows').length;
	var row={
		VSId: "",
		VSCode: "",
		VSDesc: "",
		startTime: "",
		endTime: "",
		showTime: "",
		id: ""
	}
	$('#bloodGlucose').datagrid("insertRow", { 
		row: row
  }).datagrid("selectRow", editBGIndex);
  editBGRow(editBGIndex,row)
}
function saveBGRow() {
	if (undefined==editBGIndex) {
		return $.messager.popover({msg: '无需要保存的项！',type:'alert'});
	}
	var curRow=$('#bloodGlucose').datagrid('getRows')[editBGIndex];
	var rowEditors=$('#bloodGlucose').datagrid('getEditors',editBGIndex);
	var id=curRow.id||'';
	var VSId=$(rowEditors[0].target).combobox('getValue');
	var startTime=$(rowEditors[1].target).timespinner('getValue');  
	var endTime=$(rowEditors[2].target).timespinner('getValue');  
	var showTime=$(rowEditors[3].target).checkbox('getValue')?1:'';  
	if (!VSId||!startTime||!endTime) {
		$.messager.popover({msg: '描述和时间属于必填项！',type:'alert'});
		return false;
	}
	for (var i = 0; i < bgTableData.rows.length; i++) {
		var r=bgTableData.rows[i];
		if (id==r.id) continue;
		if (VSId==r.VSId) {
			return $.messager.popover({msg: '该血糖设置已存在！',type:'alert'});
		}
		if (r.startTime<=r.endTime) {
			if (startTime<=endTime) {
				if ((startTime<=r.endTime)&&(endTime>=r.startTime)) {
					return $.messager.popover({msg: '该血糖设置的时间段与已存在的有重叠！',type:'alert'});
				}
			} else {
				if ((r.startTime>=startTime)||(r.endTime<=endTime)) {
					return $.messager.popover({msg: '该血糖设置的时间段与已存在的有重叠！',type:'alert'});
				}
			}
		} else {
			if (startTime<=endTime) {
				if ((startTime<=r.endTime)||(endTime>=r.startTime)) {
					return $.messager.popover({msg: '该血糖设置的时间段与已存在的有重叠！',type:'alert'});
				}
			} else {
				return $.messager.popover({msg: '该血糖设置的时间段与已存在的有重叠！',type:'alert'});
			}
		}
	}
	var data={
		id:id,
		VSId:VSId,
		VSCode:vsCodeObj[VSId],
		VSDesc:vsDescObj[VSId],
		startTime:startTime,
		endTime:endTime,
		showTime:showTime,
		hospDR:hospID
	}
	var updateRow=editBGIndex;
  var res=$cm({
    ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
    MethodName: 'AddOrUpdateBGConfig',
    dataType: "text",
    data:JSON.stringify(data)
  }, false);
	if (parseInt(res)==res) {
		$.messager.popover({msg: '保存成功！',type:'success'});
		var row={
    	id:id||res,
			VSId:VSId,
			VSCode:vsCodeObj[VSId],
			VSDesc:vsDescObj[VSId],
			showTime:showTime,
			startTime:startTime,
			endTime:endTime
    };
		$('#bloodGlucose').datagrid('acceptChanges').datagrid('updateRow', {
      index: updateRow,
      row: row
    });
		$('#bloodGlucose').datagrid('endEdit',editBGIndex)
		editBGIndex=undefined;
		// 更新数据
		bgTableData.rows.map(function(elem,index) {
			if (row.id==elem.id) {
				bgTableData.rows[index].VSId=row.VSId;
				bgTableData.rows[index].VSCode=row.VSCode;
				bgTableData.rows[index].VSDesc=row.VSDesc;
				bgTableData.rows[index].startTime=row.startTime;
				bgTableData.rows[index].endTime=row.endTime;
				bgTableData.rows[index].showTime=row.showTime;
			}
		});
		$('#bloodGlucose').datagrid({data: bgTableData.rows});
		return true;
	} else {
		$.messager.popover({msg: res,type:'alert'});
		return false;
	}
}
function deleteBGRow(id) {
	var bgObj = $('#bloodGlucose');
	var row=bgObj.datagrid('getSelected');
	$.messager.confirm("删除", "确定要删除此行的数据?", function (r) {
		if (r) {
			if (id) {
		    var res=$cm({
	        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
	        MethodName: 'DeleteBGConfig',
	        ID:id
		    }, false);
	    	console.log(res);
	    	if (0==res) {
	    		$.messager.popover({msg: '删除成功！',type:'success'});
					bgTableData.rows.map(function(elem,index) {
						if (id==elem.id) {
							bgTableData.rows.splice(index,1);
						}
					});
					$('#bloodGlucose').datagrid({data: bgTableData.rows});
	    	} else {
	    		$.messager.popover({msg: JSON.stringify(res),type:'alert'});
	    		return false
	    	}
			}else{
				var curInd =bgObj.datagrid('getRowIndex',row);
				bgObj.datagrid('deleteRow',curInd);
			}
			editBGIndex = undefined;
		}
	});
}
var docAdviceloader = function(param,success,error){
	var q = param.q || '';
	var delimiter = String.fromCharCode(12);
	var key=q;
	if (''===key) key=delimiter;
	if (!docAdvicesObj[key]) {
	  var docAdvices=$cm({
	    ClassName: 'Nur.NIS.Service.TaskOverview.Normal',
	    QueryName: 'GetDocAdvice',
	    rows: 200,
	    ARCIMDesc: q,
			hospDR:hospID
	  }, false);
	  docAdvicesObj[key]=docAdvices.rows;
	}
  var id=daObj.docAdviceDR;
  if (id) {
    var exist=false;
    $.map(docAdvicesObj[key], function(e) {
      if (id==e.id) exist=true;
    });
    if (!exist) docAdvicesObj[key].push({
    	id:daObj.docAdviceDR,
    	desc:daObj.adviseDesc
    });
﻿    success(docAdvicesObj[key]);
    daObj={};
  } else {
    success(docAdvicesObj[key]);
  }
}
var diagnoseloader = function(param,success,error){
	var q = param.q || '';
	var delimiter = String.fromCharCode(12);
	var key=q;
	if (''===key) key=delimiter;
	if (!diagnoseObj[key]) {
	  var diagnoses=$cm({
	    ClassName: 'Nur.NIS.Service.Education2.Setting',
	    QueryName: 'GetDiagnosisList',
	    rows: 200,
	    keyword: q,
			hospID:hospID
	  }, false);
	  diagnoseObj[key]=diagnoses.rows;
	}
  var id=dgObj.id;
  if (id) {
    var exist=false;
    $.map(diagnoseObj[key], function(e) {
      if (id==e.id) exist=true;
    });
    if (!exist) diagnoseObj[key].push(dgObj);
    success(diagnoseObj[key]);
    dgObj={};
  } else {
    success(diagnoseObj[key]);
  }
}
function getRbgdTableData() {
	// 获取放化疗评价系统数据
  rtTableData=$cm({
    ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
    QueryName: 'GetBGCommon',
    rows: 999999999999999,
    hospDR: hospID
  }, false);
	$('#rbgdTable').datagrid({data: rtTableData.rows});
	$('.Rbgd .datagrid-toolbar>table tr>td:eq(1)').html('<span>关联测血糖医嘱</span><a href="javascript:void(0);" class="helpFlag"> <span class="icon icon-help" onmouseenter="showHelpInfo(event,\'helpDocOrder\');" onmouseleave="hideHelpInfo(\'helpDocOrder\');" style="width: 16px;'+('lite'==HISUIStyleCode?'font-size:0;':'')+'">&nbsp;</span> </a>');
}
function editRbgdRow(curInd,row) {
	console.log(row);
  daObj=row;
	// 当双击另一行时，先保存正在编辑的行
	$('#rbgdTable').datagrid('beginEdit', curInd);
  var timer = setInterval(function(){
    if(!daObj.docAdviceDR) {
      clearInterval(timer);
      var rowEditor=$('#rbgdTable').datagrid('getEditors',curInd)[0];
      $(rowEditor.target).combobox('setValue',row.docAdviceDR);
    }
  },50);
}
function addRbgdRow() {
	var len=$('#rbgdTable').datagrid('getRows').length;
	var row={
		adviseCode: "",
		adviseDesc: "",
		docAdviceDR: "",
		id: ""
	}
	$('#rbgdTable').datagrid("insertRow", { 
		row: row
  }).datagrid("selectRow", len);
  editRbgdRow(len,row)
}
function saveRbgdRow() {
	var timeShow=$("#timeShow").combobox('getValue');
	var remarkShow=$("#remarkShow").combobox('getValue');
	var data={
		timeShow:timeShow,
		remarkShow:remarkShow,
    hospDR: hospID
	}
	if (!IsStandardEdition) {
		// var applyHour=$("#applyHour").numberbox('getValue');
		// data.applyHour=applyHour;
	}
  $cm({
    ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
    MethodName: 'SaveApplyHourAndTimeShow',
    dataType: "text",
    data:JSON.stringify(data)
  }, function(res) {
	  if (0!=res) {
	  	$.messager.popover({msg: res,type:'alert'});
	  }
  });
	// 保存关联测血糖医嘱
	var indexes=$('#rbgdTable').datagrid('getEditingRowIndexs');
	var n=0,m=0,submitFlag=true,allRight=true;
	var repeatObj={};
	for (var i = 0; i < indexes.length; i++) {
		(function() {
			var j=i;
			var index=indexes[j];
			if (undefined===index) return true;
			var rbgdRow=$('#rbgdTable').datagrid('getRows')[index];
			var id=rbgdRow.id,adviceObj={};
			var rowEditors=$('#rbgdTable').datagrid('getEditors',index);
			var docAdviceDR=$(rowEditors[0].target).combobox('getValue');
			if (!docAdviceDR) {
				submitFlag=false;
				return $.messager.popover({msg: "请选择医嘱！",type:'alert'});
			}
			if (repeatObj[docAdviceDR]) {
				repeatObj[docAdviceDR]+=1;
			} else {
				repeatObj[docAdviceDR]=1;
			}
			if (repeatObj[docAdviceDR]>1) {
				submitFlag=false;
				return $.messager.popover({msg: "添加的医嘱项里有重复！",type:'alert'});
			}
			// 重复校验
			var repeatFlag=false;
			rtTableData.rows.map(function(elem) {
				if ((id!=elem.id)&&(docAdviceDR==elem.docAdviceDR)) repeatFlag=true;
				if ((""==id)&&(docAdviceDR==elem.docAdviceDR)) {
					if (adviceObj[docAdviceDR]) {
						adviceObj[docAdviceDR]+=1;
					} else {
						adviceObj[docAdviceDR]=1;
					}
				}
			})
			if (repeatFlag||(adviceObj[docAdviceDR]>1)) {
				submitFlag=false;
				return $.messager.popover({msg: "医嘱已存在！",type:'alert'});
			}
			var data={
				id:id,
				docAdviceDR:docAdviceDR,
				hospDR:hospID
			}
			setTimeout(function() {
				if (!submitFlag) return;
			  $cm({
			    ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
			    MethodName: 'AddOrUpdateBGCommon',
			    dataType: "text",
			    data:JSON.stringify(data)
			  }, function(res) {
					console.log(res);
					if (parseInt(res)!=res) {
						allRight=false;
						$.messager.popover({msg: res,type:'alert'});
					}
					n++;
			  });
			},50);
		})();
	}
	var timer = setInterval(function(){
		if(n==indexes.length) {
			clearInterval(timer);
			getRbgdTableData();
			allRight && $.messager.popover({msg: "保存成功！",type:'success'});
		}
		if(m>20) {
			clearInterval(timer);
		}
		m++;
	},100);
}
function deleteRbgdRow(id) {
	var rtObj = $('#rbgdTable');
	var row=rtObj.datagrid('getSelected');
	$.messager.confirm("删除", "确定要删除此行的数据?", function (r) {
		if (r) {
			if (id) {
		    var res=$cm({
	        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
	        MethodName: 'DeleteBGCommon',
	        ID:id
		    }, false);
	    	console.log(res);
	    	if (0==res) {
	    		$.messager.popover({msg: '删除成功！',type:'success'});
					rtTableData.rows.map(function(elem,index) {
						if (id==elem.id) {
							rtTableData.rows.splice(index,1);
						}
					});
					rtObj.datagrid({data: rtTableData.rows});
	    	} else {
	    		$.messager.popover({msg: JSON.stringify(res),type:'alert'});
	    		return false
	    	}
			}else{
				var curInd =rtObj.datagrid('getRowIndex',row);
				rtObj.datagrid('deleteRow',curInd);
			}
		}
	});
}
function getDgTableData() {
	// 获取放化疗评价系统数据
  dgTableData=$cm({
    ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
    QueryName: 'GetBGDownOrder',
    rows: 999999999999999,
    hospDR: hospID
  }, false);
	$('#downGluTable').datagrid({data: dgTableData.rows});
}
function getDiagTableData() {
	// 获取放化疗评价系统数据
  diagTableData=$cm({
    ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
    QueryName: 'GetBGDiagnose',
    rows: 999999999999999,
    hospDR: hospID
  }, false);
	$('#diagnoseTable').datagrid({data: diagTableData.rows});
	// $('.relateDiagnose .transparentHeader .panel-title').html('关联糖尿病诊断 <a href="javascript:void(0);" class="helpFlag"> <span class="icon icon-help" onmouseenter="showHelpInfo(event,\'helpDiagnose\');" onmouseleave="hideHelpInfo(\'helpDiagnose\');" style="width: 16px;">&nbsp;</span> </a>');
	$('.relateDiagnose .datagrid-toolbar>table tr>td:eq(2)').html('<span>关联糖尿病诊断</span><a href="javascript:void(0);" class="helpFlag"> <span class="icon icon-help" onmouseenter="showHelpInfo(event,\'helpDiagnose\');" onmouseleave="hideHelpInfo(\'helpDiagnose\');" style="width: 16px;'+('lite'==HISUIStyleCode?'font-size:0;':'')+'">&nbsp;</span> </a>');
}
function editDgRow(curInd,row) {
  daObj=row;
	// 当双击另一行时，先保存正在编辑的行
	$('#downGluTable').datagrid('beginEdit', curInd);
  var timer = setInterval(function(){
    if(!daObj.docAdviceDR) {
      clearInterval(timer);
      var rowEditor=$('#downGluTable').datagrid('getEditors',curInd)[0];
      $(rowEditor.target).combobox('setValue',row.docAdviceDR);
    }
  },50);
}
function addDgRow() {
	var len=$('#downGluTable').datagrid('getRows').length;
	var row={
		adviseCode: "",
		adviseDesc: "",
		docAdviceDR: "",
		id: ""
	}
	$('#downGluTable').datagrid("insertRow", { 
		row: row
  }).datagrid("selectRow", len);
  editDgRow(len,row)
}
function saveDgRow() {
	// 保存降糖方案配置
	var indexes=$('#downGluTable').datagrid('getEditingRowIndexs');
	var n=0,m=0,submitFlag=true,allRight=true;

	var repeatObj={};
	for (var i = 0; i < indexes.length; i++) {
		(function() {
			var j=i;
			var index=indexes[j];
			if (undefined===index) return true;
			var rbgdRow=$('#downGluTable').datagrid('getRows')[index];
			var id=rbgdRow.id,adviceObj={};
			var rowEditors=$('#downGluTable').datagrid('getEditors',index);
			var docAdviceDR=$(rowEditors[0].target).combobox('getValue');
			if (!docAdviceDR) {
				submitFlag=false;
				return $.messager.popover({msg: "请选择医嘱！",type:'alert'});
			}
			if (repeatObj[docAdviceDR]) {
				repeatObj[docAdviceDR]+=1;
			} else {
				repeatObj[docAdviceDR]=1;
			}
			if (repeatObj[docAdviceDR]>1) {
				submitFlag=false;
				return $.messager.popover({msg: "添加的医嘱项里有重复！",type:'alert'});
			}
			// 重复校验
			var repeatFlag=false;
			dgTableData.rows.map(function(elem) {
				if ((id!=elem.id)&&(docAdviceDR==elem.docAdviceDR)) repeatFlag=true;
				if ((""==id)&&(docAdviceDR==elem.docAdviceDR)) {
					if (adviceObj[docAdviceDR]) {
						adviceObj[docAdviceDR]+=1;
					} else {
						adviceObj[docAdviceDR]=1;
					}
				}
			})
			if (repeatFlag||(adviceObj[docAdviceDR]>1)) {
				submitFlag=false;
				return $.messager.popover({msg: "医嘱已存在！",type:'alert'});
			}
			var data={
				id:id,
				docAdviceDR:docAdviceDR,
				hospDR:hospID
			}
			setTimeout(function() {
				if (!submitFlag) return;
			  $cm({
			    ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
			    MethodName: 'AddOrUpdateBGDownOrder',
			    dataType: "text",
			    data:JSON.stringify(data)
			  }, function(res) {
					console.log(res);
					if (parseInt(res)!=res) {
						allRight=false;
						$.messager.popover({msg: res,type:'alert'});
					}
					n++;
			  });
			},50);
		})();
	}
	var timer = setInterval(function(){
		if(n==indexes.length) {
			clearInterval(timer);
			getDgTableData();
			allRight && $.messager.popover({msg: "保存成功！",type:'success'});
		}
		if(m>20) {
			clearInterval(timer);
		}
		m++;
	},100);
}
function deleteDgRow(id) {
	var dgObj = $('#downGluTable');
	var row=dgObj.datagrid('getSelected');
	$.messager.confirm("删除", "确定要删除此行的数据?", function (r) {
		if (r) {
			if (id) {
		    var res=$cm({
	        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
	        MethodName: 'DeleteBGDownOrder',
	        ID:id
		    }, false);
	    	console.log(res);
	    	if (0==res) {
	    		$.messager.popover({msg: '删除成功！',type:'success'});
					dgTableData.rows.map(function(elem,index) {
						if (id==elem.id) {
							dgTableData.rows.splice(index,1);
						}
					});
					dgObj.datagrid({data: dgTableData.rows});
	    	} else {
	    		$.messager.popover({msg: JSON.stringify(res),type:'alert'});
	    		return false
	    	}
			}else{
				var curInd =dgObj.datagrid('getRowIndex',row);
				dgObj.datagrid('deleteRow',curInd);
			}
		}
	});
}
function addDiagRow() {
	var len=$('#diagnoseTable').datagrid('getRows').length;
	var row={
		diagnoseDesc: "",
		diagnoseDR: ""
	}
	$('#diagnoseTable').datagrid("insertRow", { 
		row: row
  }).datagrid("selectRow", len);
  editDiagRow(len,row)
}
function editDiagRow(curInd,row) {
  dgObj={
		id:row.diagnoseDR,
		desc:row.diagnoseDesc,
	};
	// 当双击另一行时，先保存正在编辑的行
	$('#diagnoseTable').datagrid('beginEdit', curInd);
  var timer = setInterval(function(){
    if(!dgObj.id) {
      clearInterval(timer);
      var rowEditor=$('#diagnoseTable').datagrid('getEditors',curInd)[0];
      $(rowEditor.target).combobox('setValue',row.diagnoseDR);
    }
  },50);
}
function deleteDiagRow(id) {
	var diagObj = $('#diagnoseTable');
	var row=diagObj.datagrid('getSelected');
	$.messager.confirm("删除", "确定要删除此行的数据?", function (r) {
		if (r) {
			if (id) {
		    var res=$cm({
	        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
	        MethodName: 'DeleteBGDiagnose',
	        ID:id
		    }, false);
	    	console.log(res);
	    	if (0==res) {
	    		$.messager.popover({msg: '删除成功！',type:'success'});
					getDiagTableData();
	    	} else {
	    		$.messager.popover({msg: res,type:'alert'});
	    		return false
	    	}
			}else{
				var curInd =diagObj.datagrid('getRowIndex',row);
				diagObj.datagrid('deleteRow',curInd);
			}
		}
	});
}
function saveDiagRow() {
	// 保存降糖方案配置
	var indexes=$('#diagnoseTable').datagrid('getEditingRowIndexs');
	var n=0,m=0,submitFlag=true,allRight=true;
	var repeatObj={};
	for (var i = 0; i < indexes.length; i++) {
		(function() {
			var j=i;
			var index=indexes[j];
			if (undefined===index) return true;
			var diagRow=$('#diagnoseTable').datagrid('getRows')[index];
			var id=diagRow.id,diagnoseObj={};
			var rowEditors=$('#diagnoseTable').datagrid('getEditors',index);
			var diagnoseDR=$(rowEditors[0].target).combobox('getValue');
			if (!diagnoseDR) {
				submitFlag=false;
				return $.messager.popover({msg: "请选择诊断！",type:'alert'});
			}
			if (repeatObj[diagnoseDR]) {
				submitFlag=false;
				return $.messager.popover({msg: "添加的诊断项里有重复！",type:'alert'});
			} else {
				repeatObj[diagnoseDR]=1;
			}
			// 重复校验
			var repeatFlag=false;
			diagTableData.rows.map(function(elem) {
				if ((id!=elem.id)&&(diagnoseDR==elem.diagnoseDR)) repeatFlag=true;
				if ((""==id)&&(diagnoseDR==elem.diagnoseDR)) {
					if (diagnoseObj[diagnoseDR]) {
						diagnoseObj[diagnoseDR]+=1;
					} else {
						diagnoseObj[diagnoseDR]=1;
					}
				}
			})
			if (repeatFlag||(diagnoseObj[diagnoseDR]>1)) {
				submitFlag=false;
				return $.messager.popover({msg: "诊断已存在！",type:'alert'});
			}
			var data={
				id:id,
				diagnoseDR:diagnoseDR,
				hospDR:hospID
			}
			setTimeout(function() {
				if (!submitFlag) return;
			  $cm({
			    ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
			    MethodName: 'AddOrUpdateBGDiagnose',
			    dataType: "text",
			    data:JSON.stringify(data)
			  }, function(res) {
					console.log(res);
					if (parseInt(res)!=res) {
						allRight=false;
						$.messager.popover({msg: res,type:'alert'});
					}
					n++;
			  });
			},50);
		})();
	}
	var timer = setInterval(function(){
		if(n==indexes.length) {
			clearInterval(timer);
			getDiagTableData();
			allRight && $.messager.popover({msg: "保存成功！",type:'success'});
		}
		if(m>20) {
			clearInterval(timer);
		}
		m++;
	},100);
}
function getBWTableData() {
	// 获取血糖预警配置
  $cm({
      ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
      QueryName: 'GetBGWarn',
      hospDR: hospID
  }, function (data) {
  	console.log(data);
		$('#bloodWarn').datagrid('loadData',data);
		selectBWIndex=undefined;
  });
}
function getMNTableData() {
	// 获取血糖消息通知配置
  $cm({
      ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
      QueryName: 'GetBGMessage',
      hospDR: hospID
  }, function (data) {
  	console.log(data);
		$('#msgNotify').datagrid('loadData',data);
  });
}
function toggleCritical(v) {
	if ("Y"==v) {
		$("#criticalReply").show();
	} else {
		$("#criticalReply").hide();
	}
}
function toggleRetest(v) {
	if ("Y"==v) {
		$("#retestTiming").show();
	} else {
		$("#retestTiming").hide();
	}
}
function updateModalPos(id) {
  var offsetLeft=(window.innerWidth-$('#'+id).parent().width())/2;
  var offsetTop=(window.innerHeight-$('#'+id).parent().height())/2;
  $('#'+id).dialog({
    left: offsetLeft,
    top: offsetTop
  }).dialog("open");
}
function addBWRow() {
	updateModalPos('bloodWarnModal');
	$('#bwForm').form('reset')
	$('#bwForm').form('disableValidation')
	$("#id").val('')
	// $("#color").val('');
	$("#color").minicolors('value', '');
}
//删除一行
function deleteBWRow() {
	var bwObj = $('#bloodWarn');
	var row=bwObj.datagrid('getSelected');
	if (row) {
		$.messager.confirm("删除", "确定要删除选中的数据?", function (r) {
			if (r) {
		    $cm({
		        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
		        MethodName: 'DeleteBGWarn',
		        ID:row.id
		    }, function (data) {
		    	console.log(data);
		    	if (0==data) {
		    		$.messager.popover({msg: '删除成功！',type:'success'});
						var curInd =bwObj.datagrid('getRowIndex',row);
						bwObj.datagrid('deleteRow',curInd);
						selectBWIndex = undefined;
		    	} else {
		    		$.messager.popover({msg: JSON.stringify(data),type:'alert'});
		    	}
		    });
			}
		});
	} else {
		$.messager.popover({msg: '请先选择要删除的行！',type:'alert'});
	}
}
// 选中数据引入表格
function selectBWRow(curInd) {
	selectBWIndex=curInd;
	$('#bloodWarn').datagrid('selectRow',curInd);
}
// 编辑数据引入表格
function editBWRow(curInd,row) {
	console.log(row);
	if (!row) {
		var bwObj = $('#bloodWarn');
		row=bwObj.datagrid('getSelected');
		if (!row) return $.messager.popover({msg: '请先选择行！',type:'alert'});
	}
	// $HUI.dialog('#bloodWarnModal').open();
	addBWRow();
	$("#id").val(row.id)
	$("#code").val(row.code)
	$("#name").val(row.name)
	$("#type").combobox('setValue',row.type)
	$("#variableDesc").val(row.variableDesc)
	$("#relatedBGItems").combobox('setValues',row.relatedBGItems?row.relatedBGItems.split(','):[])
	$("#condition").val(row.condition)
	// $("#color").val(row.color);
	$("#color").minicolors('value', row.color);
	// $("#color").trigger('keyup');
	
	$("#nurseMeasure").combobox("setValue",row.nurseMeasure)
	$("#nurMeasureRequire").checkbox('setValue',"Y"==row.nurMeasureRequire?true:false)
	$("#docMeasure").combobox("setValue",row.docMeasure)
	// $("#criticalFlag").combobox('setValue',row.criticalFlag)
	$("#criticalReply").val(row.criticalReply)
	$("#retestFlag").combobox('setValue',row.retestFlag)
	$("#retestTiming").numberbox('setValue',row.retestTiming)
	$("#consultFlag").combobox('setValue',row.consultFlag)
	// toggleCritical(row.criticalFlag)
	toggleRetest(row.retestFlag)
	$('#bwForm').form('validate')
}
function addMNRow() {
	updateModalPos('msgNotifyModal');
	$('#mnForm').form('reset')
	$('#mnForm').form('disableValidation')
	$('#forPeople').combobox('clear');
	$('#mnId').val('');
}
//删除一行
function deleteMNRow() {
	var mnObj = $('#msgNotify');
	var row=mnObj.datagrid('getSelected');
	if (row) {
		$.messager.confirm("删除", "确定要删除选中的数据?", function (r) {
			if (r) {
		    $cm({
		        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
		        MethodName: 'DeleteBGMessage',
		        ID:row.id
		    }, function (data) {
		    	console.log(data);
		    	if (0==data) {
		    		$.messager.popover({msg: '删除成功！',type:'success'});
						var curInd =mnObj.datagrid('getRowIndex',row);
						mnObj.datagrid('deleteRow',curInd);
		    	} else {
		    		$.messager.popover({msg: JSON.stringify(data),type:'alert'});
		    	}
		    });
			}
		});
	} else {
		$.messager.popover({msg: '请先选择要删除的行！',type:'alert'});
	}
}
// 编辑数据引入表格
function editMNRow(curInd,row) {
	console.log(row);
	if (!row) {
		var mnObj = $('#msgNotify');
		row=mnObj.datagrid('getSelected');
		if (!row) return $.messager.popover({msg: '请先选择行！',type:'alert'});
	}
	updateModalPos('msgNotifyModal');
	$("#mnId").val(row.id)
	$("#mnCode").val(row.code)
	$("#mnVariableDesc").val(row.variableDesc)
	$("#mnRelatedBGItems").combobox('setValues',row.relatedBGItems?row.relatedBGItems.split(','):[])
	$("#mnCondition").val(row.condition)
  $('#triggerTimes').numberbox('setValue', row.triggerTimes);
	$("#ruleLocs").combobox('setValues',row.ruleLocs?row.ruleLocs.split(','):[])
	$("#ruleInvalidLocs").combobox('setValues',row.ruleInvalidLocs?row.ruleInvalidLocs.split(','):[])
	$("#forPeople").combobox('setValue',row.forPeople)
	$("#messageCode").val(row.messageCode)
	$("#measures").val(row.measures)
	$('#mnForm').form('validate')
}
// 保存数据引入表格
function saveMNRow() {
	console.log($('#mnForm').form('validate'));
	$('#mnForm').form('enableValidation')
	if ($('#mnForm').form('validate')) {
		var mnCode=$("#mnCode").val();
		if (mnCode.length>32) return	$.messager.popover({msg: "变量code长度不大于32！",type:'alert'});
		var mnVariableDesc=$("#mnVariableDesc").val();
		if (''===mnVariableDesc) return	$.messager.popover({msg: "请输入变量描述！",type:'alert'});
		if (mnVariableDesc.length>500) return	$.messager.popover({msg: "变量描述长度不大于500！",type:'alert'});
		var measures=$("#measures").val();
		if (measures.length>500) return	$.messager.popover({msg: "危急值回复信息长度不大于500！",type:'alert'});
		var repeatCheck={},ruleLocs=$("#ruleLocs").combobox('getValues'),ruleInvalidLocs=$("#ruleInvalidLocs").combobox('getValues');//重复校验
		for (var i = 0; i < ruleLocs.length; i++) {
			repeatCheck[ruleLocs[i]]=1;
		}
		for (var i = 0; i < ruleInvalidLocs.length; i++) {
			if (repeatCheck[ruleInvalidLocs[i]]) {
				$.messager.popover({msg: '适用范围和不适用范围不能有相同选项！',type:'alert'});
				return false;
			} else {
				repeatCheck[ruleInvalidLocs[i]]=1;
			}
		}
		var obj={
			hospDR:hospID,
			id:$("#mnId").val(),
			code:mnCode, // 后端code查重
			variableDesc:mnVariableDesc,
			relatedBGItems:$("#mnRelatedBGItems").combobox('getValues').join(),
			condition:$("#mnCondition").val(),
			triggerTimes:$('#triggerTimes').numberbox('getValue'),
			ruleLocs:ruleLocs.join(),
			ruleInvalidLocs:ruleInvalidLocs.join(),
			forPeople:$("#forPeople").combobox('getValue'),
			messageCode:$("#messageCode").val(),
			measures:measures,
		}
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
        MethodName: 'AddOrUpdateBGMessage',
        dataType: "text",
        data:JSON.stringify(obj)
    }, function (data) {
    	console.log(data);
    	if (0==data) {
				$.messager.popover({msg: "数据保存成功！",type:'success'});
    		$HUI.dialog('#msgNotifyModal').close();
    		getMNTableData();
    	} else {
				$.messager.popover({msg: data,type:'alert'});
    	}
    });
		return true;
	}
}
// 手填颜色
function handFillingColor() {
	$("#handFilling").hide();
	$("#color").css({
		'background-color':$("#color").val(),
		color:getContraryColor($("#color").val())
	}).attr('type', 'text').keyup(function(event) {
		console.log(arguments);
		console.log($(this).val());
		var val=$(this).val().toUpperCase();
		if ((7!=val.length)||(!val.match(/#[\dA-F]{6}/))) return;
		$(this).css({
			'background-color':$(this).val(),
			color:getContraryColor(val)
		})
	});
}
// 获取相反的颜色
function getContraryColor(val) {
	var color="#";
	for (var i = 1; i < val.length; i=i+2) {
		var s='0'+(255-parseInt(val.slice(i,i+2),16)).toString(16);
		color+=s.slice(-2);
	}
	console.log(color);
	return color;
}
// 保存数据引入表格
function saveBWRow() {
	console.log($('#bwForm').form('validate'));
	$('#bwForm').form('enableValidation')
	if ($('#bwForm').form('validate')) {
		// var criticalFlag=$("#criticalFlag").combobox('getValue');
		var retestFlag=$("#retestFlag").combobox('getValue'),retestTiming=('Y'==retestFlag)?$("#retestTiming").numberbox('getValue'):'';
		console.log($("#nurMeasureRequire").checkbox('getValue'));
		if (('Y'==retestFlag)&&(''==retestTiming)) {
			return	$.messager.popover({msg: "请输入复测时效！",type:'alert'});
		}
		// var criticalReply=('Y'==criticalFlag)?$("#criticalReply").val():'';
		// if (('Y'==criticalFlag)&&(''==criticalReply)) {
		// 	return	$.messager.popover({msg: "请输入危急值回复信息！",type:'alert'});
		// }
		var variableDesc=$("#variableDesc").val();
		if (''===variableDesc) {
			return	$.messager.popover({msg: "请输入变量描述！",type:'alert'});
		}
		var obj={
			hospDR:hospID,
			id:$("#id").val(),
			code:$("#code").val(),
			name:$("#name").val(),
			type:$("#type").combobox('getValue'),
			variableDesc:variableDesc,
			relatedBGItems:$("#relatedBGItems").combobox('getValues').join(),
			condition:$("#condition").val(),
			color:$("#color").val(),
			nurseMeasure:$("#nurseMeasure").combobox("getValue"),
			nurMeasureRequire:$("#nurMeasureRequire").checkbox('getValue')?"Y":"N",
			docMeasure:$("#docMeasure").combobox("getValue"),
			// criticalFlag:criticalFlag,
			// criticalReply:criticalReply,
			retestFlag:retestFlag,
			retestTiming:retestTiming,
			consultFlag:$("#consultFlag").combobox('getValue'),
		}
    $cm({
        ClassName: 'Nur.NIS.Service.VitalSign.BloodGlucoseCfg',
        MethodName: 'AddOrUpdateBGWarn',
        dataType: "text",
        data:JSON.stringify(obj)
    }, function (data) {
    	console.log(data);
    	if (0==data) {
				$.messager.popover({msg: "数据保存成功！",type:'success'});
    		$HUI.dialog('#bloodWarnModal').close();
    		getBWTableData();
    	} else {
				$.messager.popover({msg: JSON.stringify(data),type:'alert'});
    	}
    });
		return true;
	}
}
function resizeTableHeight() {
	var innerHeight=window.innerHeight;
	var halfpHeight=(innerHeight-148)/2-2;
	if (IsStandardEdition) halfpHeight=innerHeight-154;
	console.log(halfpHeight);
  $('#bloodGlucose').datagrid('resize',{
    height:halfpHeight
	});
  $('#commonSet').panel('resize',{
    height:IsStandardEdition?(halfpHeight+35):(halfpHeight+35)
	});
  $('#rbgdTable').datagrid('resize',{
    width:$('#commonSet').width(),
    height:halfpHeight-(IsStandardEdition?122:120)
	});
  $('#downGluTable').datagrid('resize',{
    height:halfpHeight
	});
	if (!IsStandardEdition) {
	  $('#bloodWarn').datagrid('resize',{
	    height:halfpHeight-8
		});
	  $('#diagnoseTable').datagrid('resize',{
	    height:innerHeight-153
		});
	  $('#msgNotify').datagrid('resize',{
	    height:innerHeight-118
		});
	}
  $('#eduSetTab').tabs({
    height: innerHeight - 60,
  });
}
setTimeout(resizeTableHeight,100);
window.addEventListener("resize",resizeTableHeight);
