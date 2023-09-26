var recjson = "";
var SCODE = "";
var SName = "";
var CCODE = "";
var CName = "";
var CSCODE = "";
var CSName = "";
var TemplateId = "";
var recCategory = "";
var recDetial = "";
var bindString = "";
var parent = "";
var grandparent = "";
var TYPE = "";
var recbindString = "";
var rectype = "";
var VTYPE = "";

///获取病历模板的MetaData
function getXml(RecordId) {
	TemplateId = RecordId;
	jQuery.ajax({
		type : "get",
		dataType : "text",
		url : "../EMRservice.Ajax.common.cls",
		async : true,
		data : {
			"OutputType" : "Stream",
			"Class" : "EMRservice.BL.BLBindQuery",
			"Method" : "GetMetaData",
			"p1" : RecordId
		},
		success : function (d) {
			readXml(d);
		},
		error : function (d) {
			alert("getXml error");
		}
	});
}

///进行模板的xml解析
function readXml(xmlstring) {
	var xmlDoc = convertToXml(xmlstring);
	var nodes = xmlDoc.documentElement.childNodes[0].childNodes;
	recjson = "";
	recjson = recjson + '[';
	for (var i = 0; i < nodes.length; i++) {
		GetSection(nodes[i].childNodes);
		recjson = recjson + '}';
		if (i < (nodes.length - 1)) {
			recjson = recjson + ',';
		}
	}
	recjson = recjson + ']';
	recjson = recjson.replace(/\s/g, ""); //去掉空格
	recjson = recjson.replace(/[\r\n]/g, ""); //去掉回车换行
	recjson = JSON.parse(recjson);
	//加载病历具体字段
	$('#dataEMRDeital').tree({
		async : true,
		loadMsg : '数据装载中......',
		lines : true,
		data : recjson,
		onSelect : function () {
			recCategory = "";
			recDetial = "";
			recbindString = "";
			parent = "";
			grandparent = "";
			TYPE = "";
			rectype = "";
			recCategory = $('#dataEMRCategory').tree('getSelected');
			recDetial = $("#dataEMRDeital").tree('getSelected');
			rectype = recDetial.attributes.type;
			//设置取值类型下拉框
			if (rectype == "Section") {
				//所选为章节
				$('#valueType').combobox({
					valueField : 'value',
					textField : 'label',
					data : [{
							label : '文本',
							value : 'T'
						}, {
							label : '样式',
							value : 'S'
						}
					],
					onLoadSuccess : function (data) {
						if (data) {
							$('#valueType').combobox('setValue', data[0].value);
						}
					}
				});
				TYPE = "ISectionDesc";
				recbindString = recCategory.text + "." + recDetial.text;
			} else if (rectype == "Composite") {
				//所选为复合元素
				$('#valueType').combobox({
					valueField : 'value',
					textField : 'label',
					data : [{
							label : '文本',
							value : 'T'
						}, {
							label : '样式',
							value : 'S'
						}
					],
					onLoadSuccess : function (data) {
						if (data) {
							$('#valueType').combobox('setValue', data[0].value);
						}
					}
				});
				TYPE = "ICompositeDesc";
				parent = $('#confirmSelect').tree('getParent', recDetial.target)
					recbindString = recCategory.text + "." + parent.text + "." + recDetial.text;
			} else {
				//所选为简单元素
				if (rectype == "MIString") //字符
				{
					$('#valueType').combobox({
						valueField : 'value',
						textField : 'label',
						data : [{
								label : '值',
								value : 'V'
							}
						],
						onLoadSuccess : function (data) {
							if (data) {
								$('#valueType').combobox('setValue', data[0].value);
							}
						}
					});
				} else if (rectype == "MINumber") //数字
				{
					$('#valueType').combobox({
						valueField : 'value',
						textField : 'label',
						data : [{
								label : '值',
								value : 'V'
							}
						],
						onLoadSuccess : function (data) {
							if (data) {
								$('#valueType').combobox('setValue', data[0].value);
							}
						}
					});
				} else if (rectype == "MIMonoChoice") //单选
				{
					$('#valueType').combobox({
						valueField : 'value',
						textField : 'label',
						data : [{
								label : '值',
								value : 'V'
							}, {
								label : '代码',
								value : 'C'
							}, {
								label : '值^代码',
								value : 'VANDC'
							}, {
								label : '单选',
								value : 'Mono'
							}
						],
						onLoadSuccess : function (data) {
							if (data) {
								$('#valueType').combobox('setValue', data[0].value);
							}
						}
					});
				} else if (rectype == "MIMultiChoice") //多选
				{
					$('#valueType').combobox({
						valueField : 'value',
						textField : 'label',
						data : [{
								label : '值',
								value : 'V'
							}, {
								label : '代码',
								value : 'C'
							}, {
								label : '值^代码',
								value : 'VANDC'
							}, {
								label : '多选',
								value : 'Mult'
							}
						],
						onLoadSuccess : function (data) {
							if (data) {
								$('#valueType').combobox('setValue', data[0].value);
							}
						}
					});
				} else if (rectype == "MIDateTime") //时间
				{
					$('#valueType').combobox({
						valueField : 'value',
						textField : 'label',
						data : [{
								label : '值',
								value : 'V'
							}, {
								label : '代码',
								value : 'C'
							}, {
								label : '值^代码',
								value : 'VANDC'
							}, {
								label : '年',
								value : 'YEAR'
							}, {
								label : '月',
								value : 'MONTH'
							}, {
								label : '日',
								value : 'DAY'
							}, {
								label : '小时',
								value : 'HOUR'
							}, {
								label : '分',
								value : 'MINUTE'
							}, {
								label : '秒',
								value : 'SECOND'
							}
						],
						onLoadSuccess : function (data) {
							if (data) {
								$('#valueType').combobox('setValue', data[0].value);
							}
						}
					});
				} else if (rectype == "MIDictionary") //字典
				{
					$('#valueType').combobox({
						valueField : 'value',
						textField : 'label',
						data : [{
								label : '值',
								value : 'V'
							}, {
								label : '代码',
								value : 'C'
							}, {
								label : '值和代码',
								value : 'VC'
							}, {
								label : '代码和值',
								value : 'VC'
							}, {
								label : '值^代码',
								value : 'VANDC'
							}, {
								label : '字典',
								value : 'Dict'
							}
						],
						onLoadSuccess : function (data) {
							if (data) {
								$('#valueType').combobox('setValue', data[0].value);
							}
						}
					});
				}
				TYPE = "ICompositeSample";
				parent = $('#confirmSelect').tree('getParent', recDetial.target);
				grandparent = $('#confirmSelect').tree('getParent', parent.target);
				recbindString = recCategory.text + "." + grandparent.text + "." + parent.text + "." + recDetial.text;
			}
			VTYPE = $('#valueType').combobox('getValue');
		},
		onLoadError : function () {
			alert("dataEMRDeitalonLoadError");
		}
	});
}

//解析章节为json数据
function GetSection(sections) {
	for (var i = 0; i < sections.length; i++) {
		if (sections[i].nodeName == "Component") {
			//递归遍历子章节
			var Secnodes = sections[i].childNodes;
			for (var i = 0; i < Secnodes.length; i++) {
				GetSection(Secnodes[i].childNodes);
				recjson = recjson + '}';
				if (i < (Secnodes.length - 1)) {
					recjson = recjson + ',';
				}
				if (i == (Secnodes.length - 1)) {
					recjson = recjson + ']';
				}
			}
		} else if (sections[i].nodeName == "Code") {
			//遍历章节取得属性
			SCODE = sections[i].getAttribute('Code');
			SName = sections[i].getAttribute('DisplayName');
			recjson = recjson + '{';
			recjson = recjson + '"id"' + ':' + '"' + SCODE + '"' + ',';
			recjson = recjson + '"text"' + ':' + '"' + SName + '"' + ',';
			recjson = recjson + '"attributes"' + ':' + '{';
			recjson = recjson + '"type"' + ':' + '"' + 'Section' + '"' + ',';
			recjson = recjson + '"path"' + ':' + '"' + 'SCODE' + ':' + SCODE + '"';
			recjson = recjson + '}';
			if (sections.length != 1) {
				recjson = recjson + ',';
				recjson = recjson + '"children"' + ':' + '[';
			}
		} else {
			GetComposite(sections[i].childNodes);
			recjson = recjson + '}';
			if (i < (sections.length - 1)) {
				recjson = recjson + ',';
			}
			if (i == (sections.length - 1)) {
				recjson = recjson + ']';
			}
		}

	}
}

//解析复合元素为json数据
function GetComposite(Composites) {
	for (var i = 0; i < Composites.length; i++) {
		//遍历复合元素
		if (Composites[i].nodeName == "Code") {
			//遍历复合元素取得属性
			CCODE = Composites[i].getAttribute('Code');
			CName = Composites[i].getAttribute('DisplayName');
			recjson = recjson + '{';
			recjson = recjson + '"id"' + ':' + '"' + CCODE + '"' + ',';
			recjson = recjson + '"text"' + ':' + '"' + CName + '"' + ',';
			recjson = recjson + '"attributes"' + ':' + '{';
			recjson = recjson + '"type"' + ':' + '"' + 'Composite' + '"' + ',';
			recjson = recjson + '"path"' + ':' + '"' + 'SCODE' + ':' + SCODE + '|' + 'CCODE' + ':' + CCODE + '"';
			recjson = recjson + '}';
		} else {
			var Sample = Composites[i].childNodes;
			if (Sample.length != 0) {
				recjson = recjson + ',';
				recjson = recjson + '"children"' + ':' + '[';
				GetSample(Sample);
			}
		}
	}
}

//解析简单元素为json数据
function GetSample(Sample) {
	for (var i = 0; i < Sample.length; i++) {
		var SampleType = Sample[i].nodeName;
		CSCODE = Sample[i].getElementsByTagName("Code")[0].firstChild.nodeValue;
		CSName = Sample[i].getElementsByTagName("DisplayName")[0].firstChild.nodeValue;
		if (i != 0) {
			recjson = recjson + ",";
		}
		recjson = recjson + '{';
		recjson = recjson + '"id"' + ':' + '"' + CSCODE + '"' + ',';
		recjson = recjson + '"text"' + ':' + '"' + CSName + '"' + ',';
		recjson = recjson + '"attributes"' + ':' + '{';
		recjson = recjson + '"type"' + ':' + '"' + SampleType + '"' + ',';
		recjson = recjson + '"path"' + ':' + '"' + 'SCODE' + ':' + SCODE + '|' + 'CCODE' + ':' + CCODE + '|' + 'CSCODE' + ':' + CSCODE + '"';
		recjson = recjson + '}';

		recjson = recjson + '}';
		if (i == (Sample.length - 1)) {
			recjson = recjson + "]";
		}
	}
}

$(function () {
	//绑定病历数据的确定按钮
	$("#confirmSelect").click(function () {
		if (!$("#BindCode") || $("#BindCode").length <= 0)
			return;
		var tab = $('#databind').tabs('getSelected');
		var bindType = tab[0].id;
		var bindString = "";
		if (bindType == "EPR") {
			if (recCategory && recDetial) {
				VTYPE = $('#valueType').combobox('getValue');
				bindString = recbindString + "#" + "TYPE:" + TYPE + "#" + "TID:" + TemplateId + "#" + recDetial.attributes.path + "#" + "VTYPE:" + VTYPE;
				$("#BindCode").val(bindString);
				$("#BindType").val(bindType);
				$("#setPropty").accordion('select', '基本属性');
			}
		}
	});
});
