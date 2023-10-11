/**
 * FileName: dhcbill.ipbill.patbatch.import.js
 * Author: ZhYW
 * Date: 2022-12-12
 * Description: 住院批量导入
 */

$(function () {
	initQueryMenu();
    initPatList();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-import", {
        onClick: function () {
            importClick();
        }
    });
}

function initPatList() {
	var toolbar = [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function () {
				saveClick();
			}
		}];
    GV.PatList = $HUI.datagrid("#patList", {
        fit: true,
        border: false,
        singleSelect: true,
        rownumbers: true,
        pagination: false,
        pageSize: 99999999,
        toolbar: toolbar,
        columns: [[ {title: '转诊上报日期', field: 'ReferDate', width: 120},
				    {title: '现收治医院', field: 'HospitalSource', width: 150},
					{title: '现收治科室', field: 'DeptSource' ,width: 150},
					{title: '患者姓名', field: 'PatName', width: 100},
					{title: '身份证号', field: 'PatID', width: 160},
					{title: '性别', field: 'PatSex', width: 60},
					{title: '年龄', field: 'PatAge', width: 60},
					{title: '联系电话',field: 'Telephone', width: 120},
					{title: '近亲属联系电话',field: 'ForeignPhone', width: 120},
					{title: '住址', field: 'Address', width: 200, showTip: true},
				    {title: '职业', field: 'Occupation', width: 100},
					{title: '发病日期', field: 'OnsetDate', width: 120},
					{title: '简要病史', field: 'MedicalHistory', width: 150},
					{title: '当前临床症状',field: 'CurrentSymptoms', width: 170},
					{title: '最高体温', field: 'TemperatureMax', width: 80, align: 'right'},
					{title: '流行病学史', field: 'EpidemicHistory', width: 100},
					{title: '疑似病人接触史', field: 'PatContactHistory', width: 150, showTip: true},
					{title: '肺部CT', field: 'CTResults', width: 80},
					{title: '采血结果', field: 'BloodTestResults', width: 80},
					{title: '血病原检测', field: 'BloodSourceDetection', width: 100},
					{title: '氧疗情况', field: 'OxygenTherapy', width: 80},
					{title: '氧饱和度', field: 'OxygenSaturation', width: 100},
					{title: '是否上呼吸机', field: 'IsUseBreathingMachine', width: 100},
					{title: '治疗用药及治疗天数', field: 'TreatmentDays', width: 150},
					{title: '是否合并重要脏器功能衰竭', field: 'OrganFailure', width: 180},
					{title: '病情情况', field: 'StateOfIllness', width: 80},
					{title: '冠状病毒性肺炎临床分型', field: 'ClinicalType', width: 170},
					{title: '采样日期', field: 'SamplingDate',  width: 100},
					{title: '采样结果', field: 'SamplingResults', width: 100},
					{title: '是否确诊', field: 'IsDefiniteDiagnosis', width: 100}
			]]
    });
}

/**
* 导入
*/
function importClick() {
     //文件流转BinaryString
     //解决 xls 读取进异常的问题 bug
	var _fixData = function(data) {
		var o = "",w = 10240;
		for(var l = 0; l < data.byteLength / w; ++l) {
     		o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
  		}
   		o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
  		return o;
	};
	
	//将数组数据转化为datagrid需要的数据格式
    var _arr2GridData = function(arr) {
        //第一行为标题，第二行为标题代码
        var title = [];
        for (var p in arr[1]) {
            if (!arr[1].hasOwnProperty(p)) {
                continue;
            }
            title.push(arr[1][p]);
        }
        //从2开始是因为第一行是标题，第二行为标题代码
        var rows = [];
        for (var i = 2, len = arr.length; i < len; i++) {
            var row = {};
            var j = 0;
            for (var p in arr[i]) {
                if (!arr[i].hasOwnProperty(p)) {
                    continue;
                }
                var key = title[j++];
                $.extend(row, {[key]: arr[i][p]});
            }
            rows.push(row);
        }
        return {"rows": rows, "total": rows.length};
    };
	
	if ($("#btn-import").linkbutton("options").disabled) {
		return;
	}
	$("#btn-import").linkbutton("toggleAble");
	
	var files = $("#file").filebox("files");
	if (files.length == 0) {
		$.messager.popover({msg: "请选择文件", type: "info"});
		return;
	}
	
	$.messager.progress({title: "提示", text: "数据导入中..."});
	var reader = new FileReader();
	reader.readAsArrayBuffer(files[0]);   //以数组形式
	reader.onload = function(e) {
		var data = e.target.result;
 		var workbook = XLSX.read(btoa(_fixData(data)), {type: "base64"});  //(binary/base64)
 		var result = XLSX.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]]);  //只读取第一张sheet
        var data = _arr2GridData(result);
        //将数据加载到页面
        GV.PatList.loadData(data);
     	$.messager.progress("close");
	};
}

function saveClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			var data = GV.PatList.getData();
			rows = data.rows;
			if (rows.length == 0) {
				$.messager.popover({msg: "待保存数据为空，请先导入数据", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认保存？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _save = function() {
		return new Promise(function (resolve, reject) {
			$.m({
		    	ClassName: "BILL.IP.BL.BatchReg",
		    	MethodName: "SavePatInfo",
		    	patList: JSON.stringify(rows),
		    	sessionStr: getSessionStr()
		    }, function(rtn) {
			    var myAry = rtn.split("^");
			    $.messager.alert("提示", (myAry[1] || myAry[0]), "info", function() {
				    resolve();
				});
			    return;
			});
		});
	};
	
	var _success = function() {
		$("#file").filebox("clear");
		GV.PatList.loadData({rows: [], total: 0});
	};
	
	var $this = $(event.target);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var rows = [];
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_save)
		.then(function() {
			_success();
			$this.prop("disabled", false);
		}, function() {
			$this.prop("disabled", false);
		});
}