var patNode={},curPage=1,lastRecord,eduOptions,dateformat,saveFlag=true,checkFlag=true,deleteFlag=false;
var columns=[],eduTaskList=[],eduTaskIds=[];
var page=1, pageSize=10,treeObj,sys={},multiConfig={};
var patientInfo={};
var delimiter = String.fromCharCode(12);
var unfoldFlag=true;//��������չ����ʶ
var onClickFlag=false, checkNode,docAdvicesTimer;
if ('undefined'==typeof HISUIStyleCode) {
	var HISUIStyleCode="blue";
}
var eduTreeFlodFlag=localStorage.getItem("eduTreeFlodFlag"+session['LOGON.USERID']);
if (!eduTreeFlodFlag) {
	eduTreeFlodFlag=1; // չ��
}else{
	eduTreeFlodFlag=parseInt(eduTreeFlodFlag);
}
var frm = dhcsys_getmenuform();
console.log(frm);
if (frm) {
	patNode={
		episodeID:frm.EpisodeID.value,
		patientID:frm.PatientID.value
	}
}
$(function() {
	init();
});
function init() {
	if (!IsShowPatList) {
		$(".ctcContent").prev().hide();
		$(".ctcContent").css('width','100%');
	}
	if ('lite'==HISUIStyleCode) { //����
		$('.eduExeStyle').append('#edusubjectInput {width: 195px !important;height: 28px;}');
		$('.eduExeStyle').append('#eduTaskModal td[field="taskId"] .l-btn-icon{padding: 0!important;}');
		if (!IsPopUp) { //�ǵ���
			$('.eduExeStyle').append('body {background-color: #f5f5f5;}');
		}
	} else {
		$('.eduExeStyle').append('#edusubjectInput {width: 162px !important;height: 30px;}');
		$('.eduExeStyle').append('.panel-body, .panel-header{border-color: #cccccc;}');
	}
	if (EpisodeID !== "") {
		patNode.episodeID=EpisodeID;
		if (IsShowPatInfoBannner) InitPatInfoBanner(EpisodeID)
	}
	// ��ȡ���ڸ�ʽ
  var res=$cm({
    ClassName: 'Nur.NIS.Service.System.Config',
    MethodName: 'GetSystemConfig'
  }, false);
  dateformat=res.dateformat;
  patientInfo=$cm({
    ClassName: 'Nur.CommonInterface.Patient',
    MethodName: 'getPatient',
    episodeID: EpisodeID,
  }, false);
	patientInfo.inHospDateTime=patientInfo.inHospDateTime?patientInfo.inHospDateTime.trim():'';
	patientInfo.regDateTime=patientInfo.regDateTime?patientInfo.regDateTime.trim():'';
	$('#stopDate').datebox('setValue', formatDate(new Date()));
	$('#startDate').datebox('setValue', dateCalculate(new Date(), -3));
	$('#eduDate').datebox('setValue', formatDate(new Date()));
	$("input[name='eduPeriod'][value='0']").radio("setValue", true);
	$('#eduTime').timespinner('setValue', new Date().toString().split(' ')[4].slice(0,5));
	$('#beginDate').datebox('setValue', dateCalculate(new Date(), -6));
	$('#endDate').datebox('setValue', formatDate(new Date()));
	// ����domԪ�صĴ�С
	updateDomSize();
	getPatEduInfo();
  // ��ȡҵ����������ѡ����
  $cm({
      ClassName: "Nur.NIS.Service.Education2.Setting",
      MethodName: "GetEduMultiExeConfig",
      hospDR: session['LOGON.HOSPID'],
    }, function (data) {
			multiConfig=data;
			getEdusubjectTreeData();
    }
  );
	treeObj=$HUI.treegrid("#docAdvicesTable",{
		autoSizeColumn:false,
		checkbox:true,
		// columns:[columns],
		idField:'id',
		treeField:'oeCatDesc',
		headerCls:'panel-header-gray',
		toolbar: '#drugToolbar',
		pagination:true,
		selectOnCheck:true,
		singleSelect : false,
		onClickRow:function(id,row){
			console.log(arguments);
			docAdvicesTimer=setTimeout(function() {
				if (row.checked) {
					$('#docAdvicesTable').treegrid('uncheckNode', id);
				} else {
					$('#docAdvicesTable').treegrid('checkNode', id);
					
				}
			}, 100);
		},
		onCheckNode:function(row,checked){
			console.log(arguments);
			clearInterval(docAdvicesTimer);
			var flag="select";
			if (row._parentId) row=$('#docAdvicesTable').treegrid('getParent', row.id);
			updateTreegridStatus("docAdvicesTable", flag, row);
		}
	})
	getDrugState();
	sys=$cm({
    ClassName: 'Nur.NIS.Service.VitalSign.Result',
    MethodName: 'GetPrintParamEDU'
  }, false);
	$("#toggleFold").off().click(function(argument) {
			var operator;
			if (unfoldFlag) {
					unfoldFlag = false;
					operator = "collapse";
					$('#toggleFold').linkbutton({
						iconCls:'icon-unindent',
					});
			} else {
					unfoldFlag = true;
					operator = "expand";
					$('#toggleFold').linkbutton({
						iconCls:'icon-indentation',
					});
			}
			localStorage.setItem("eduTreeFlodFlag"+session['LOGON.USERID'],unfoldFlag?1:0);
			var roots = $("#edusubjectTree").tree("getRoots");
			var $edusubjectTree = $('#edusubjectTree');
			roots.map(function(e) {
					if (e.children) {
							var target = $edusubjectTree.tree('find', e.id).target
							$edusubjectTree.tree(operator, target);
					}
			})
			roots = $("#edusubjectTreeComm").tree("getRoots");
			var $edusubjectTreeComm = $('#edusubjectTreeComm');
			roots.map(function(e) {
					if (e.children) {
							var target = $edusubjectTreeComm.tree('find', e.id).target
							$edusubjectTreeComm.tree(operator, target);
					}
			})
	});
	// rejectERRow();
	if (session['LOGON.GROUPDESC'].indexOf('��ʿ��')>-1) $('td.reject').show();
}
// ������������״̬
function updateTreegridStatus(id, flag, row) {
	console.log(row.checked);
	$('#'+id).treegrid((row.checked?'':'un')+flag, row.id);
	if (row.children) {
		row.children.map(function (r) {
			updateTreegridStatus(id, flag, r);
		})
	}
}
// �л����̲�ѯ����
function changeEduPeriod(e, flag) {
	console.log(arguments);
	var inHospDay=(patientInfo.inHospDateTime||patientInfo.regDateTime).split(' ');
  if (flag) {
    switch (parseInt(e.target.value)) {
      case 0:
				$('#stopDate').datebox('setValue', formatDate(new Date()));
				$('#startDate').datebox('setValue', dateCalculate(new Date(), -3));
        break;
      case 1:
				$('#stopDate').datebox('setValue', formatDate(new Date()));
				$('#startDate').datebox('setValue', inHospDay[0]);
        break;
    }
		getEducationColumnAndRecord();
  }
}
function getPatEduInfo() {
	// ��ȡ����������Ϣ
	getEducationColumnAndRecord();
	updateEduTaskAndReturnList();
}
function printEducationRecord() {
	$cm({
		ClassName: 'NurMp.Discharge.Authority',
		MethodName: 'getPatAction',
		dataType: "text",
		EpisodeId: patNode.episodeID,
		MouldType: "JKXJ",
		UserID: session['LOGON.USERID'],
		Action: "print",
	}, function (data) {
		if (1!=data) {
			$.messager.popover({msg: $g('��Ժ����δ�Դ˲�����Ȩ��'),type:'alert'});
		}else {
			var locationURL = window.location.href.split("/csp/")[0]; // + "/"
			var rows=$("#eduRecordTable").datagrid('getChecked');
			var ids = [];
			rows.map(function(e) {
				ids.push(e.eduRecordId)
			})
			console.log(ids.join("@"));
		  // ��ӡ���̼�¼
		  AINursePrintAll(
		    // sys.serverURL,
		    locationURL,
		    sys.emrPrintCode,
		    patNode.episodeID.toString(),
		    // patNode.episodeID.toString(),
		    ids.join("@"),
		    // "",
		    0
		  );
		}
	});
}
function getEducationColumnAndRecord() {
	if (!patNode.episodeID) return;
  $cm({
    ClassName: 'Nur.NIS.Service.Education2.Biz',
    MethodName: 'GetEducationColumnAndRecordNew',
    dataType: "text",
    AdmDR: patNode.episodeID,
    wardID: session['LOGON.WARDID'],
    hospID: session['LOGON.HOSPID'],
    startDate: $('#startDate').datebox('getValue'),
    endDate: $('#stopDate').datebox('getValue'),
    keyword: $('#subject').val()
  }, function (data) {
  	// console.log(data);
  	data=JSON.parse(data)
  	data.data=data.data||[];
  	data.lastRecord=data.lastRecord||[];
    data.data.map(function(elem, index) {
      var keys = Object.keys(elem);
      keys.map(function(key) {
        if (elem[key].toString().indexOf(delimiter)>-1) {
          var opt = elem[key].split(delimiter);
          data.data[index][key] = opt[0] + "(" + opt[1] + ")";
        }
      });
			data.data[index].eduContent=elem.eduContent.replace(/\n/g,'<br>')
    });
    data.lastRecord.map(function(elem, index) {
      var keys = Object.keys(elem);
      keys.map(function(key) {
        if (elem[key].toString().indexOf(delimiter)>-1) {
          var opt = elem[key].split(delimiter);
          data.lastRecord[index][key] = opt[0] + "(" + opt[1] + ")";
        }
      });
    });

  	lastRecord=data.lastRecord;
  	var columns=[
	  		{
				field:"ck",
				checkbox:true
			},
	  		{
				field:"eduDateTime",
				title:$g("����ʱ��"),
				width:120
			},
			{
				field:"eduSubject",
				title:$g("����"),
				width:132
			},
			{
				field:"eduContent",
				title:$g("��������"),
				width:Math.max(650-data.columns.length*78,300),
				wordBreak:"break-all"
			}
		];
  	data.columns.map(function(e,i) {
  		if (i<3) return;
  		if (["eduRecordId","taskId"].indexOf(e.dataIndex)>-1) return;
  		columns.push({
				field:e.dataIndex,
				title:e.title,
				width:78,formatter:function(value,row,i){
					return $g(value);
				}
  		})
  	})
  	$('#eduRecordTable').datagrid({
			columns:[columns],
			nowrap:false,
			data:{total:data.data.length,rows:data.data},
			onLoadSuccess: function (data){
				console.log(data);
				data=data.rows;
				if (!data.length) return
				var mergeFields = Object.keys(data[0]);
				mergeFields.push("ck");
				var idStart=0,subjectStart=0;
				var idNo=1,subjectNo=1;
				for(var i=1; i<data.length; i++){
					if (data[i-1].eduRecordId==data[i].eduRecordId) {
						idNo++;
						if ((data[i-1].eduSubject==data[i].eduSubject)&&(data[i-1].taskId==data[i].taskId)) {
							subjectNo++;
						} else {
							if (subjectNo>1) {
								$('#eduRecordTable').datagrid('mergeCells',{
									index: subjectStart,
									field: 'eduSubject',
									rowspan: subjectNo
								});
							}
							subjectStart=i;
							subjectNo=1;
						}
					} else {
						if (idNo>1) {
							mergeFields.map(function (mf) {
								if (["eduSubject","eduContent","subjectIds","eduRecordId","taskId"].indexOf(mf)>-1) return;
								$('#eduRecordTable').datagrid('mergeCells',{
									index: idStart,
									field: mf,
									rowspan: idNo
								});
							})
							if (subjectNo>1) {
								$('#eduRecordTable').datagrid('mergeCells',{
									index: subjectStart,
									field: 'eduSubject',
									rowspan: subjectNo
								});
							}
						}
						idStart=i;
						idNo=1;
						subjectStart=i;
						subjectNo=1;
					}
					if (idNo>1) {
						mergeFields.map(function (mf) {
							if (["eduSubject","eduContent","subjectIds","eduRecordId"].indexOf(mf)>-1) return;
							$('#eduRecordTable').datagrid('mergeCells',{
								index: idStart,
								field: mf,
								rowspan: idNo
							});
						})
						if (subjectNo>1) {
							$('#eduRecordTable').datagrid('mergeCells',{
								index: subjectStart,
								field: 'eduSubject',
								rowspan: subjectNo
							});
						}
					}
				}
			}
		});
	  getEduOptions();
  });
}
function updateEduTaskAndReturnList(flag) {
	if (!patNode.episodeID) return;
  $cm({
    ClassName: 'Nur.NIS.Service.Education2.Biz',
    MethodName: 'UpdateEduTaskAndReturnList',
    Adm: patNode.episodeID,
    WardID: session['LOGON.WARDID'],
    UserId: session['LOGON.USERID'],
    LocId: session['LOGON.CTLOCID'],
    HospDR: session['LOGON.HOSPID']
  }, function (data) {
    eduTaskList = data;
    if (eduTaskList.length) {
    	$("#eduTask").linkbutton({text:$g('��������')+'<span>('+eduTaskList.length+')</span>'}).linkbutton('enable');
    	if (flag) getEduTaskContents();
    } else {
    	$("#eduTask").linkbutton({text:$g('��������')}).linkbutton('disable');
			$HUI.dialog('#eduTaskModal').close();
    }
  });
}
function getEduOptions() {
	if (!eduOptions) {
		eduOptions=$cm({
			ClassName: 'Nur.NIS.Service.Education2.HealthRecord',
			MethodName: 'GetHealthEduItemOptions',
			dataType: "text",
			wardId: session['LOGON.WARDID']
		}, false);
		eduOptions=JSON.parse(eduOptions)
	}
	$("#eduDateTime").nextUntil("#remark").remove();
	eduOptions.map(function(e) {
		var options=e.options.toString().split('/');
		if (1==e.blankFlag) {
			options.push($g('����'));
		}
		var tr='<tr><td><span><span style="color: red;">*</span>'+$g(e.name)+'</span></td><td></td></tr>'
		$("#remark").before(tr);
		var record=lastRecord[0];
		var $td=$("#remark").prev().find('td:eq(1)');
		if (1==e.type) { //��ѡ
			options.map(function(o,i) {
				var item='<input class="hisui-checkbox bgItem" type="checkbox" data-id="'+o+'" label="'+o+'" id="option'+e.id+'_'+i+'">';
				$td.append(item);
				$td.find("input:eq(-1)").checkbox({
					label: o,
					value: o,
					checked: false
				});
			})
		} else {
			options.map(function(o,i) {
				var item='<input class="hisui-radio bgItem" type="radio" data-id="'+o+'" label="'+o+'" id="option'+e.id+'_'+i+'" name="'+e.name+'">';
				$td.append(item);
				$td.find("input:eq(-1)").radio({
					label: o,
					value: o,
					checked: false
				});
			})
		}
		if (1==e.blankFlag) {
				var item='<input style="width: 120px;" class="hisui-validatebox textbox validatebox-text">';
				$td.append(item);
		}
		if (record&&record['option'+e.id]) {
			var selOptions=record['option'+e.id].split('/');
			selOptions.map(function(so) {
				var index=options.indexOf(so);
				if (so.indexOf($g('����')+'(')>-1) {
					index=options.indexOf($g('����'));
					$td.find("input.textbox").val(so.replace($g('����')+'(','').slice(0,-1));
				}
				if (1==e.type) {
					$td.find('#option'+e.id+'_'+index).checkbox('setValue',true);
				} else {
					$td.find('#option'+e.id+'_'+index).radio('setValue',true);
				}
			})
		}
	})
}
// ��ȡ�������νṹ����
function getEdusubjectTreeData() {
	// �Ȼ�ȡȫԺ����
  var hospitalEduSubject=$cm({
    ClassName: 'Nur.NIS.Service.Education2.Setting',
    MethodName: 'GetEduSubjectList',
    WardId: "",
    StartFlag: 1,
    episodeId: EpisodeID,
  }, false);
  var pid={0:[]}; //tabҳǩ��������
  hospitalEduSubject.map(function(e) {
		e.iconCls="hideTreeIcon";
		e.text=e.desc;
		if (pid[e.pid]) {
			pid[e.pid].push(e);
		} else {
			pid[e.pid]=[e];
		}
	});
	pid[0].sort(function(a,b){
		return parseInt(a.sortNo)-parseInt(b.sortNo)
	})
	var keys=Object.keys(pid);
	keys.map(function (k) {
		pid[k].map(function (e, i) {
			if (pid[e.id]) {
				pid[e.id].sort(function (a, b) {
					return parseInt(a.sortNo) - parseInt(b.sortNo);
				});
				pid[k][i].children = pid[e.id];
			}
		});
	});
	$('#edusubjectTreeComm').tree({
		lines:true,
		iconCls:"hideTreeIcon",
		onlyLeafCheck:1==multiConfig.add?false:true,
		data: pid[0],
		onClick: function (node) {
			if (1!=multiConfig.add) {
				if (0==node.pid) return;
				uncheckSubjects();
			}
			var flag=node.checked?'uncheck':'check';
			$('#edusubjectTreeComm').tree(flag,node.target);
		},
		onCheck: function (node) {
			console.log(node);
			if (1!=multiConfig.add) uncheckSubjects(node);
			if (!checkFlag) return;
			var nodesComm = $('#edusubjectTreeComm').tree('getChecked'); //tabҳǩ��������
			var nodes = $('#edusubjectTree').tree('getChecked');
			var ids=[];
			nodes.map(function(e) {
				if (1 == e.leafFlag) ids.push(e.id);
			})
			nodesComm.map(function(e) {
				if (1 == e.leafFlag) ids.push(e.id);
			})
			getEduContentsByIds(ids);
		}
	})
	// �ٻ�ȡ��Ժ������
	$cm({
		ClassName: 'Nur.NIS.Service.Education2.Setting',
		MethodName: 'GetEduSubjectList',
		WardId: session['LOGON.WARDID'],
		StartFlag: 1,
		episodeId: EpisodeID,
	}, function (data) {
		if(data.length==0){
			$("#edusubjectTreeTabs").tabs("close","������");	//û��ά������������ʾȫԺ
		}
  	var pid={0:[]};
  	data.map(function(e) {
			e.iconCls="hideTreeIcon";
  		e.text=e.desc;
  		if (pid[e.pid]) {
  			pid[e.pid].push(e);
  		} else {
  			pid[e.pid]=[e];
  		}
  	});
		pid[0].sort(function(a,b){
			return parseInt(a.sortNo)-parseInt(b.sortNo)
		})
		var keys=Object.keys(pid);
		keys.map(function (k) {
			pid[k].map(function (e, i) {
				if (pid[e.id]) {
					pid[e.id].sort(function (a, b) {
						return parseInt(a.sortNo) - parseInt(b.sortNo);
					});
					pid[k][i].children = pid[e.id];
				}
			});
		});
  	$('#edusubjectTree').tree({
  		lines:true,
			iconCls:"hideTreeIcon",
			onlyLeafCheck:1==multiConfig.add?false:true,
			data: pid[0],
			onClick: function (node) {
				onClickFlag=true;
				console.log(node);
				if (1!=multiConfig.add) {
					if (0==node.pid) return;
					uncheckSubjects();
				}
				var flag=node.checked?'uncheck':'check';
				$('#edusubjectTree').tree(flag,node.target);
				setTimeout(function() {
					onClickFlag=false;
				}, 250);
			},
			onCheck: function (node) {
				if (!checkFlag) return;
				if (onClickFlag) {
					var nodes = $('#edusubjectTree').tree('getChecked');
					var nodesComm = $('#edusubjectTreeComm').tree('getChecked'); //tabҳǩ��������
					var ids=[];
					nodes.map(function(e) {
						if (1 == e.leafFlag) ids.push(e.id);
					})
					nodesComm.map(function(e) {
						if (1 == e.leafFlag) ids.push(e.id);
					})
					getEduContentsByIds(ids);
				} else {
					if (!checkNode) {
						checkNode=node;
						if (1!=multiConfig.add) uncheckSubjects(node);
						setTimeout(function() {
							checkNode='';
						}, 250);
						var nodes = $('#edusubjectTree').tree('getChecked');
						var nodesComm = $('#edusubjectTreeComm').tree('getChecked'); //tabҳǩ��������
						var ids=[];
						nodes.map(function(e) {
							if (1 == e.leafFlag) ids.push(e.id);
						})
						nodesComm.map(function(e) {
							if (1 == e.leafFlag) ids.push(e.id);
						})
						getEduContentsByIds(ids);
					}
				}
			}
		})
  });
}
function uncheckSubjects(n) {
	if (n&&(0==n.pid)) {
		n=n.children[0];
	}
	var nodes = $('#edusubjectTree').tree('getChecked');
	var nodesComm = $('#edusubjectTreeComm').tree('getChecked'); //tabҳǩ��������
	if (nodes&&nodes.length) {
		nodes.map(function(e) {
			if (0==e.pid) return;
			if (n&&(n.id==e.id)) return;
			deleteFlag=true;
			$('#edusubjectTree').tree('uncheck',e.target);
		})
	}
	if (nodesComm&&nodesComm.length) {
		nodesComm.map(function(e) {
			if (0==e.pid) return;
			if (n&&(n.id==e.id)) return;
			deleteFlag=true;
			$('#edusubjectTreeComm').tree('uncheck',e.target);
		})
	}
	deleteFlag=false;
}
function getEduContentsByIds(ids) {
	if (deleteFlag) {
		deleteFlag=false;
		if (!ids||!ids.length) $('#eduTreegrid').treegrid('loadData', {rows:[]});
		return;
	}
	if (!ids||!ids.length) {
		$('#eduTreegrid').treegrid('loadData', {rows:[]});
		return
	}
	// ��ȡ���������б�
  	$cm({
		ClassName: 'Nur.NIS.Service.Education2.Setting',
		MethodName: 'GetEduContentsByIds',
		dataType: "text",
		subjectIds:JSON.stringify(ids),
		forbidFlag: true
  	}, function (res) {
  		res=JSON.parse(res);
		var data=[],maxNum=0;
		res.map(function (r) {
			maxNum=Math.max(maxNum,r.subjectId)
		});
		maxNum++;
		res.map(function (r,i) {
			var subjectNo=maxNum++;
			data.push({
				id:subjectNo,
				subjectId:r.subjectId,
				pid:0,
				eduContent:r.title,
				taskId:eduTaskIds[i]||''
			})
			r.content.map(function (c) {
				data.push({
					id:maxNum++,
					pid:r.subjectId,
					_parentId:subjectNo,
					eduContent:c,
					taskId:eduTaskIds[i]||''
				})
			})
		})
		var treegridObj = $HUI.treegrid("#eduTreegrid",{
			fitColumns:true,
			idField:'id',
			treeField:'eduContent',
			headerCls:'panel-header-gray',
			// height:data.length*30+200,
			height:'auto',
			nowrap:false,
			columns:[[
				{title:'����',field:'eduContent',width:550,align:'left',editor:'textarea'},
				{title:'����',field:'operate',width:70,formatter:function(value,row,i){
					return '<span class="gradeBtn" iconCls="icon-write-order" title="'+$g('�༭')+'" onclick="editETgRow(\''+row.id+'\',event)">&nbsp;</span><span class="gradeBtn" iconCls="icon-cancel" title="'+$g('ɾ��')+'" onclick="deleteETgRow(\''+row.id+'\',\''+row.subjectId+'\',\''+row.pid+'\',event)">&nbsp;</span>';
				}},
			]],
			onLoadSuccess:function(){
			  	$('.gradeBtn').linkbutton({plain:true}).tooltip({position:'bottom'})
			},
		});
		treegridObj.loadData({rows:data})
		return;
  	});
}
function editETgRow(id,e) {
	e.stopPropagation();
	if ($(e.target).hasClass('icon-write-order')) {
		$('#eduTreegrid').treegrid('beginEdit', id);
	} else {
		$('#eduTreegrid').treegrid('endEdit', id);
		$('.gradeBtn').linkbutton({plain:true}).tooltip({position:'bottom'})
		$('.tooltip.tooltip-bottom').hide();
	}
	$(e.target).toggleClass('icon-write-order').toggleClass('icon-ok');
}
function deleteETgRow(id,subjectId,pid,e) {
	e.stopPropagation();
	if (0==pid) {
		deleteFlag=true;
		var nodes = $('#edusubjectTree').tree('getChecked');
		nodes.map(function(n) {
			if (subjectId==n.id) {
				$('#edusubjectTree').tree('uncheck',n.target);
			}
		})
		nodes = $('#edusubjectTreeComm').tree('getChecked');
		nodes.map(function(n) {
			if (subjectId==n.id) {
				$('#edusubjectTreeComm').tree('uncheck',n.target);
			}
		})
	}
	$('#eduTreegrid').treegrid('remove', id);
	$('.tooltip.tooltip-bottom').hide();
}
function preExeEduTask() {
	// Ԥִ�д�������
	$("#remarks").val('');
	var rows=$('#eduTaskTable').datagrid('getChecked');
	var ids=[];
	eduTaskIds=[];
	rows.map(function(e) {
		ids.push(e.subjectId);
		eduTaskIds.push(e.taskId);
	})
	getEduContentsByIds(ids);
	updateModalPos('eduExeModal');
	$("#ardsTree").hide();
	updateExeModalStyle();
}
function getEduTaskContents() {
	var ids=[];
	eduTaskList.map(function(e) {
		ids.push(e.subjectId)
	})
  	$cm({
		ClassName: 'Nur.NIS.Service.Education2.Setting',
		MethodName: 'GetEduContentsByIds',
		dataType: "text",
		subjectIds:JSON.stringify(ids),
		forbidFlag: true
  	}, function (res) {
		res=JSON.parse(res);
		var data=[];
		eduTaskList.map(function(e,i) {
			data.push({
				planDate:e.planDate,
				subjectId:e.subjectId,
				taskId:e.taskId,
				pid:res[i].pid,
				title:res[i].title,
				content:res[i].content.join('\r\n'),
			})
		})
		$('#eduTaskTable').datagrid('uncheckAll');
		$('#eduTaskTable').datagrid('loadData',{rows:data});
		updateModalPos('eduTaskModal');
		$("#exeEduTask").linkbutton('disable');
  	});
}
// ��׼������
function standardizeDate(day) {
	var y=dateformat.indexOf('YYYY');
	var m=dateformat.indexOf('MM');
	var d=dateformat.indexOf('DD');
	var str=day.slice(y,y+4)+'/'+day.slice(m,m+2)+'/'+day.slice(d,d+2);
	return str;
}
function addOrUpdateEducation2Record (curInd,row) {
	// �������޸�����ִ�н��
	var contents=[];
	var t = $('#eduTreegrid');
	var rows = t.treegrid('getChildren');
	if (!rows.length) return $.messager.popover({msg: $g('��ѡ���������⣡'),type:'alert'});
	rows.map(function (r) {
		t.treegrid('endEdit', r.id);
	})
	rows = t.treegrid('getChildren');
	console.log(rows);
	for(var i=0; i<rows.length; i++){
		var r = rows[i];
		if ((0==r.pid)&&(!r.children||!r.children.length)) {
			return $.messager.popover({msg: $g('�������ⲻ��û���������ݣ�'),type:'alert'});
		}
		if (''===r.eduContent) {
			t.treegrid('beginEdit', r.id);
			return $.messager.popover({msg: $g('������������ݲ���Ϊ�գ�'),type:'alert'});
		}
		if (r.eduContent.length>2000) {
			t.treegrid('beginEdit', r.id);
			return $.messager.popover({msg: $g('����������������ݳ��Ȳ�����2000�֣�'),type:'alert'});
		}
		contents.push({
			subjectId:r.pid?"":r.subjectId,
			pid:r.pid||0,
			eduContent:r.eduContent,
			taskId:r.taskId,
		})
	}
	var remark=$("#remarks").val();
	var eduDate=$('#eduDate').datebox('getValue');
	var eduTime=$('#eduTime').timespinner('getValue');
	if (!eduDate||!eduTime) return $.messager.popover({msg: $g('�������ڲ���Ϊ�գ�'),type:'alert'});
	if (new Date(standardizeDate(eduDate)+' '+eduTime).valueOf()>new Date().valueOf()) return $.messager.popover({msg: $g('�������ڲ��ܴ��ڵ�ǰʱ�䣡'),type:'alert'});
	var itemList=[],itemFlag=false;
	eduOptions.map(function(e,i) {
		var option='';
    var $tr=$("#exeTable>tbody>tr:eq("+(2+i)+")");
    var options=e.options.toString().split('/');
    if (1==e.blankFlag) {
      options.push($g('����'));
    }
		// $td.find('#option'+e.id+'_'+index).radio('setValue',true);
    if (1==e.type) { //��ѡ
      options.map(function(o,index) {
      	if ($tr.find('#option'+e.id+'_'+index).checkbox('getValue')) {
      		if ($g('����')==o) {
      			var blank=$tr.find("input.textbox").val()
      			if (!blank) {
      				itemFlag=true;
      				return;
      			}
      			option+=o+delimiter+blank+'/'
      		} else {
      			option+=o+'/'
      		}
      	}
      })
    } else {
      options.map(function(o,index) {
      	if ($tr.find('#option'+e.id+'_'+index).radio('getValue')) {
      		if ($g('����')==o) {
      			var blank=$tr.find("input.textbox").val()
      			if (!blank) {
      				itemFlag=true;
      				return;
      			}
      			option+=o+delimiter+blank+'/'
      		} else {
      			option+=o+'/'
      		}
      	}
      })
    }
    if (!option) {
    	itemFlag=true;
    	return;
    }
		itemList.push({
			id:e.id,
			option:option.slice(0,-1)
		})
	})
	if (itemFlag) return $.messager.popover({msg: $g('����ִ������д��������'),type:'alert'});
	var id=$("#eduId").val();
	var subjectIds=[];
	// var nodes = $('#edusubjectTree').tree('getChecked');
	// var nodesComm = $('#edusubjectTreeComm').tree('getChecked'); //tabҳǩ��������
	// nodes.map(function(e) {
	// 	if (1 == e.leafFlag) subjectIds.push(e.id);
	// })
	// nodesComm.map(function(e) {
	// 	if (1 == e.leafFlag) subjectIds.push(e.id);
	// })
	// if (!subjectIds.length) {
	// }
	contents.map(function (c) {
		if (0==c.pid) {
			subjectIds.push(c.subjectId);
		}
	})
  $cm({
    ClassName: 'Nur.NIS.Education2',
    MethodName: 'AddOrUpdateEducation2RecordNew',
    dataType: "text",
    AdmDR: patNode.episodeID,
    contents: JSON.stringify(contents),
    remark: remark,
    EducationDate: eduDate,
    EducationTime: eduTime,
    EduItemList: JSON.stringify(itemList),
    UserId: session['LOGON.USERID'],
    LocId: session['LOGON.CTLOCID'],
    WardId: session['LOGON.WARDID'],
    id: id,
    SubjectIds: JSON.stringify(subjectIds),
    eduTaskIds: JSON.stringify(eduTaskIds)
  }, function (res) {
	if ('-1000'==res) {
		var oldOk = $.messager.defaults.ok;
		var oldNo = $.messager.defaults.no;
		$.messager.defaults.ok = $g("������Ȩ");
		$.messager.defaults.no = $g("ȡ��");
		var btns = $.messager.confirm($g("��ʾ"), $g("�����ѳ�Ժ�����Ʋ������������Ժ������Ȩ"), function (r) {
			if (true===r) {
				var url='nur.emr.dischargerecordauthorizeapply.csp?mouldType=JKXJ&regNo='+patientInfo.regNo; 
				if ("undefined" != typeof websys_getMWToken) {
				  url += "&MWToken=" + websys_getMWToken();
				}
				window.location.href=url;
			}
			/*Ҫд�ڻص�������,�����ھɰ��¿��ܲ��ܻص�����*/
			$.messager.defaults.ok = oldOk;
			$.messager.defaults.no = oldNo;
		}).children("div.messager-button");
		btns.children("a.l-btn").css({width:'auto'});
		$(".window-shadow").map(function (i,obj) {
			$(obj).css({height:$(obj).prev().height()});
		});
      } else if (0==res) {
  		$.messager.popover({msg: $g('����ִ�гɹ���'),type:'success'});
  		$("#remarks").val('');
		var nodes = $('#edusubjectTree').tree('getChecked');
		nodes.map(function(e) {
			deleteFlag=true;
			$('#edusubjectTree').tree('uncheck',e.target);
		})
		var nodesComm = $('#edusubjectTreeComm').tree('getChecked');
		nodesComm.map(function(e) { //tabҳǩ��������
			deleteFlag=true;
			$('#edusubjectTreeComm').tree('uncheck',e.target);
		})
		$('.tree-node-selected').removeClass('tree-node-selected');
		getEducationColumnAndRecord();
		if (eduTaskIds.length) {
			eduTaskIds=[];
			updateEduTaskAndReturnList(true);
			$HUI.dialog('#eduExeModal').close();
		}
  	} else {
  		$.messager.popover({msg: res,type:'alert'});
  	}
  });
}
function updateExeModalStyle() {
	var inputWidth=$("#edusubjectInput").parent().width()-$("#edusubjectInput+a").width()-21;
	$("#edusubjectInput").css('width', inputWidth+'px');
	var $tr=$("#eduDateTime").nextUntil("#remark");
	// $tr=Array.from($tr);
	$tr.map(function(i, e) {
		if ($(e).find('td:eq(1)').height()>50) {
			$(e).find('td:eq(0)').css({
				verticalAlign: 'top',
		    paddingTop: '6px'
			});
			if ("BR"!=$(e).find('input[label="'+$g("����")+'"]').prev()[0].nodeName) {
				$(e).find('input[label="'+$g("����")+'"]').before("<br>");
			}
			$(e).find('input[label="'+$g("����")+'"]').nextAll().css('margin-top','10px');
		}
	})
  $('#eduPanel').panel('resize', {
  	height:Math.max($('#ardsTree>.panel').height(),605)
  });
	updateModalPos('eduExeModal');
}
function addERRow(flag) {
	checkFlag=false;
	$("#eduId").val('');
	var treegridObj = $HUI.treegrid("#eduTreegrid",{
		fitColumns:true,
		idField:'id',
		treeField:'eduContent',
		headerCls:'panel-header-gray',
		height:'auto',
		nowrap:false,
		columns:[[
		{title:'����',field:'eduContent',width:550,align:'left',editor:'textarea'},
		{title:'����',field:'operate',width:60,formatter:function(value,row,i){
			return '<span class="l-btn-icon icon-write-order gradeBtn" onclick="editETgRow(\''+row.id+'\',event)">&nbsp;</span><span class="l-btn-icon icon-cancel gradeBtn" onclick="deleteETgRow(\''+row.id+'\',\''+row.pid+'\',event)">&nbsp;</span>';
		}},
		]]
	});
	treegridObj.loadData({rows:[]})
  // $("#exeTable tr:eq(0) td:eq(1)").html("");
  // $("#editContent").val("");
  $("#remarks").val("");
	var nodes = $('#edusubjectTree').tree('getChecked');
	nodes.map(function(e) {
		$('#edusubjectTree').tree('uncheck', e.target);
	});
	var nodesComm = $('#edusubjectTreeComm').tree('getChecked'); //tabҳǩ��������
	nodesComm.map(function(e) {
		$('#edusubjectTreeComm').tree('uncheck', e.target);
	});
	checkFlag=true;
	updateModalPos('eduExeModal');
  $HUI.dialog('#eduExeModal').setTitle(flag?$g('�༭����ִ��'):$g('��������ִ��'));
	$("#ardsTree").show();
	updateExeModalStyle();
	if (0==eduTreeFlodFlag) {
		$("#toggleFold").click();
		eduTreeFlodFlag=2;
	}
}
function editERRow(curInd,row) {
	addERRow(1);
	var record=row;
	var rows=$('#eduRecordTable').datagrid('getRows');
	var subject,subjectId,maxNum=0,data=[];
	if ('string'==typeof row.subjectIds) {
		var subjectIds=JSON.parse(row.subjectIds);
	} else {
		var subjectIds=JSON.parse(JSON.stringify(row.subjectIds));
	}
	subjectIds.map(function (s) {
		maxNum=Math.max(maxNum,parseInt(s));
	})
	maxNum++;
	var taskId='',subjectNo=0;
	rows.map(function (r) {
		if (!r.subjectIds) return;
		if (row.eduRecordId==r.eduRecordId) {
			if ((subject!=r.eduSubject)||(taskId!=r.taskId)) {
				subjectNo=maxNum++;
				taskId=r.taskId;
				subject=r.eduSubject
				subjectId=subjectIds.shift();
				data.push({
					id:subjectNo,
					subjectId:subjectId,
					pid:0,
					eduContent:subject,
					taskId:taskId||''
				})
			}
			data.push({
				id:maxNum++,
				pid:subjectId,
				_parentId:subjectNo,
				eduContent:r.eduContent,
				taskId:taskId||''
			})
		}
	})
	// $HUI.treegrid("#eduTreegrid").loadData({rows:data})
	$('#eduTreegrid').treegrid('loadData', {rows:data});

	checkFlag=false;
	if ('string'==typeof row.subjectIds) {
		var subjectIds=JSON.parse(row.subjectIds);
	} else {
		var subjectIds=row.subjectIds;
	}
	if($('#edusubjectTree')[0]){  //tabҳǩ���������ж�
		subjectIds.map(function(e) {
		    var node = $('#edusubjectTree').tree('find', e);
		    if(!!node){  //tabҳǩ���������ж�
			    $('#edusubjectTree').tree('check', node.target);
			}
		});
	}
	subjectIds.map(function(e) { //tabҳǩ��������
		var node = $('#edusubjectTreeComm').tree('find', e);
		if(!!node){
		   $('#edusubjectTreeComm').tree('check', node.target);
		}
	});
	checkFlag=true;

  $("#eduId").val(row.eduRecordId);
  $("#remarks").val(row.remark);
  // $("#exeTable tr:eq(0) td:eq(1)").html(row.eduSubject);
  // $("#editContent").val(row.eduContent.replace(/<br>/g,'\n'));
  $('#eduDate').datebox('setValue',row.eduDateTime.split(' ')[0]);
  $('#eduTime').timespinner('setValue',row.eduDateTime.split(' ')[1]);
	eduOptions.map(function(e,i) {
    var $td=$("#exeTable tr:eq("+(3+i)+") td:eq(1)");
    // $td.find('#option'+e.id+'_'+index).checkbox('setValue',true);
    $td.find('[id^=option'+e.id+']').checkbox('setValue',false);
    $td.find("input.textbox").val('');
		var options=e.options.toString().split('/');
		if (1==e.blankFlag) {
			options.push($g('����'));
		}
		if (record&&record['option'+e.id]) {
			var selOptions=record['option'+e.id].split('/');
			selOptions.map(function(so) {
        var index=options.indexOf(so);
        if (so.indexOf($g('����')+'(')>-1) {
          index=options.indexOf($g('����'));
          $td.find("input.textbox").val(so.replace($g('����')+'(','').slice(0,-1));
        }
        if (1==e.type) {
          $td.find('#option'+e.id+'_'+index).checkbox('setValue',true);
        } else {
          $td.find('#option'+e.id+'_'+index).radio('setValue',true);
        }
			})
		}
	});
	// updateHeight('editContent');
}
function updateHeight(id) {
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
// ����ģ̬��λ��
function updateModalPos(id) {
  var offsetLeft=(window.innerWidth-$('#'+id).parent().width())/2;
  var offsetTop=(window.innerHeight-$('#'+id).parent().height())/2;
  $('#'+id).dialog({
    left: offsetLeft,
    top: offsetTop
  }).dialog("open");
}
function checkERRow(index,row) {
	var rows=$("#eduRecordTable").datagrid('getChecked');
	var len=rows.length;
	rows.map(function (r) {
		var keys=Object.keys(r);
		if ((keys.indexOf('ck')>-1)&&(undefined==r.ck)) {
			len--;
		}
	})
	if (len) $("#cancelRecord").linkbutton('enable');
	if (len) $("#rejectRecord").linkbutton('enable');
}
function uncheckERRow(index,row) {
	var rows=$("#eduRecordTable").datagrid('getChecked');
	var len=rows.length;
	rows.map(function (r) {
		var keys=Object.keys(r);
		if ((keys.indexOf('ck')>-1)&&(undefined==r.ck)) {
			len--;
		}
	})
	if (len<1) $("#cancelRecord").linkbutton('disable');
	if (len<1) $("#rejectRecord").linkbutton('disable');
}
function deleteERRow() {
	$.messager.confirm($g("ȡ��ִ��"), $g("ȷ��ȡ����ǰ����ִ�н����"), function (r) {
		if (r) {
			var rows=$("#eduRecordTable").datagrid('getChecked');
			var ids = [];
			rows.map(function(e) {
				ids.push(e.eduRecordId)
			})
	    $cm({
        ClassName: 'Nur.NIS.Service.Education2.Biz',
        MethodName: 'CancelEducationResult',
		    dataType: "text",
        ids:ids.join(),
        userId:session['LOGON.USERID']
	    }, function (data) {
	    	if (0==data) {
	    		$.messager.popover({msg: $g('ȡ��ִ�гɹ���'),type:'success'});
					getEducationColumnAndRecord();
					$("#cancelRecord").linkbutton('disable');
					$("#rejectRecord").linkbutton('disable');
	    	} else {
	    		$.messager.popover({msg: data,type:'alert'});
	    	}
	    });
		}
	});
}
function rejectERRow() {
	$.messager.confirm($g("����"), $g("�˲�����������ִ���������ݣ�")+'<br><input class="hisui-checkbox" type="checkbox" label="'+$g("���²����������")+'" id="reinsert">', function (r) {
		if (r) {
			var rows=$("#eduRecordTable").datagrid('getChecked');
			var ids = [];
			rows.map(function(e) {
				ids.push(e.eduRecordId)
			})
			var reinsertFlag=$("#reinsert").checkbox('getValue')?1:"";
	    $cm({
        ClassName: 'Nur.NIS.Service.Education2.Biz',
        MethodName: 'RejectEducationResult',
		    dataType: "text",
        ids:ids.join(),
        userId:session['LOGON.USERID'],
        reinsert:reinsertFlag
	    }, function (data) {
	    	if (0==data) {
	    		$.messager.popover({msg: $g('����ִ�гɹ���'),type:'success'});
					getEducationColumnAndRecord();
					if (reinsertFlag) updateEduTaskAndReturnList();
					$("#cancelRecord").linkbutton('disable');
					$("#rejectRecord").linkbutton('disable');
	    	} else {
	    		$.messager.popover({msg: data,type:'alert'});
	    	}
	    });
		}
	});
	$("#reinsert").checkbox({
    checked: false
  });
}
function checkETRow(index,row) {
	var rows=$("#eduTaskTable").datagrid('getChecked');
	if ((1!=multiConfig.task)&&(rows.length>1)) {
		$("#eduTaskTable").datagrid('uncheckAll');
		$("#eduTaskTable").datagrid('checkRow',index);
	}
	$("#exeEduTask").linkbutton('enable');
}
function uncheckETRow(index,row) {
	var rows=$("#eduTaskTable").datagrid('getChecked');
	if (!rows.length) $("#exeEduTask").linkbutton('disable');
}
function deleteETRow(id,i,e) {
	e.stopPropagation();
	$.messager.confirm($g("ɾ��"), $g("��ȷ��Ҫɾ��������������"), function (r) {
		if (r) {
	    $cm({
        ClassName: 'Nur.NIS.Service.Education2.Biz',
        MethodName: 'DeleteEducationTask',
        ID:id
	    }, function (data) {
	    	if (0==data) {
	    		$.messager.popover({msg: $g('��������ɾ���ɹ���'),type:'success'});
					$('#eduTaskTable').datagrid("deleteRow", i);
					var tableData=$("#eduTaskTable").datagrid("getRows");
					$('#eduTaskTable').datagrid('loadData',{rows:tableData});
					updateEduTaskAndReturnList();
					uncheckETRow();
	    	} else {
	    		$.messager.popover({msg: data,type:'alert'});
	    	}
	    });
		}
	});
}
function getDocAdvices() {
	var nodes=treeObj.getCheckedNodes('checked');
	if (!nodes.length) return $.messager.popover({msg: $g('��ѡ��ҽ����'),type:'alert'});
	var remark="";
	nodes.map(function(e) {
		remark+='\r\n'+e.oeDesc;
	});
	var remarks=$('#remarks').val();
	if (remarks) {
		$('#remarks').val(remarks+remark);
	} else {
		$('#remarks').val(remark.slice(2));
	}
	updateHeight('remarks');
	$HUI.dialog('#drugModal').close();
}
$("#drugModal").dialog({
	onClose: function () {
		$('#docAdvicesTable').treegrid('unselectAll');
		// �ѽڵ�����Ϊδ��ѡ
		var nodes = $('#docAdvicesTable').treegrid('getCheckedNodes');
		console.log(nodes);
		var $docAdvicesTable=$('#docAdvicesTable');
		for ( var i = 0; i < nodes.length; i++) {
			$docAdvicesTable.treegrid('uncheckNode', nodes[i].id);
		}
	}
});
$("#eduExeModal").dialog({
	onOpen: function () {
		var width=0,$tr=$("#eduDateTime").prev().nextAll();
		$tr.map(function (i,t) {
		  var display=$(t).css('display');
		  console.log(display);
		  if ('none'!=display) {
			var w=$(t).find('td>span').width();
			if (w>width) width=w;
		  }
		})
		$("#exeTable>colgroup>col:eq(0)").attr('style','width:'+(width+10)+'px');
	},
	onClose: function () {
		$("#edusubjectInput").val('');
		filterEdusubject();
		$('.tree-node-selected').removeClass('tree-node-selected');
	}
});
function filterTreeNodes(nodes,id,searchText) {
	for (var i = 0; i < nodes.length; i++) {
		if (!nodes[i].target) {
			nodes[i].target= $('#'+id).tree('find', nodes[i].id).target;
		}
    if ((nodes[i].text.indexOf(searchText)>-1)||(getPinyin(nodes[i].text).toUpperCase().indexOf(searchText.toUpperCase())>-1)) {
      $(nodes[i].target).parent().show().addClass('showNode').prevAll('.showNode').removeClass('showNode');
      if (nodes[i].children) {
      	showChildNodes(nodes[i].children,id)
      }
    } else {
    	if (checkChildHas(nodes[i],searchText)) {
	      $(nodes[i].target).parent().show().addClass('showNode').prevAll('.showNode').removeClass('showNode');
    		filterTreeNodes(nodes[i].children,id,searchText);
    	} else {
	      $(nodes[i].target).parent().hide().removeClass('showNode');
    	}
    }
  }
}
function checkChildHas(node,searchText) {
	var children=node.children,flag=false;
	if (children) {
		for (var i = 0; i < children.length; i++) {
			if ((children[i].text.indexOf(searchText)>-1)||(getPinyin(children[i].text).toUpperCase().indexOf(searchText.toUpperCase())>-1)) {
				return true;
			} else {
				flag=checkChildHas(children[i],searchText)
				if (flag) {
					return true;
				}
			}
		}
	}
	return false;
}
function showChildNodes(nodes,id) {
	for (var i = 0; i < nodes.length; i++) {
		if (!nodes[i].target) {
			nodes[i].target= $('#'+id).tree('find', nodes[i].id).target;
		}
    $(nodes[i].target).parent().show().addClass('showNode').prevAll('.showNode').removeClass('showNode');
    if (nodes[i].children) {
    	showChildNodes(nodes[i].children,id)
    }
  }
}
function filterEdusubject() { // ������������
	var searchText=$("#edusubjectInput").val();
	if ($("#edusubjectTree").length) {
		var roots = $("#edusubjectTree").tree("getRoots");
		filterTreeNodes(roots,'edusubjectTree',searchText);
	}
	if ($("#edusubjectTreeComm").length) {
		var rootsComm = $("#edusubjectTreeComm").tree("getRoots"); //tabҳǩ��������
		filterTreeNodes(rootsComm,'edusubjectTreeComm',searchText);
	}
}
function clearTreeNodeSearch() {
  //��ʾ���н��
  var root = $("#edusubjectTree,#edusubjectTreeComm").tree("getRoot"); //tabҳǩ��������
  var nodes = $("#edusubjectTree,#edusubjectTreeComm").tree("getChildren", root.target); //tabҳǩ��������
  for (var i = 0; i < nodes.length; i++) {
    $(nodes[i].target).parents("li:eq(0)").css("display", "");
  }
}
// ��ȡ��ҩ���
function getDrugState() {
	saveFlag=false;
	var startDate=$('#beginDate').datebox('getValue');
	var endDate=$('#endDate').datebox('getValue');
  	$cm({
		ClassName: 'Nur.NIS.Service.Education2.Biz',
		QueryName: 'GetTypeOrderInPeriod',
		page: page,
		rows: pageSize,
		AdmDR: patNode.episodeID,
		startDate:startDate,
		endDate:endDate,
		type:"R"
  	}, function (data) {
		var rows=[];
		data.rows.map(function(e,i) {
			var children=e.children;
			delete e.children;
			e.id=e.id.replace('||','_')+'_'+i
			rows.push(e);
			if (children) {
				var children=JSON.parse(children);
				children.map(function(c) {
					// if (c.id) c.id=c.id.replace('||','_')
					if (c.itmMastDr) c.id=c.itmMastDr.replace('||','_')+'_'+e.id;
					c._parentId=e.id;
					rows.push(c);
				})
			}
		});
		treeObj.loadData({
			total:data.total,
			rows:rows
		});
		$('#docAdvicesTable').datagrid("getPager").pagination({
			onSelectPage:function(p,size){
				page=p;
				pageSize=size;
				if (saveFlag) {
					getDrugState();
				} else {
					saveFlag=true;
				}
			},
			onRefresh:function(p,size){
				page=p;
				pageSize=size;
				getDrugState();
			},
			onChangePageSize:function(size){
				page=1;
				pageSize=size;
				getDrugState();
			}
		}).pagination('select', page);
  	})
}
function setDateboxOption() {
	var startDate=$("#startDate").datebox('getValue'),stopDate=$("#stopDate").datebox('getValue');
	var startOpt=$("#startDate").datebox('options'),stopOpt=$("#stopDate").datebox('options');
	if (startDate) stopOpt.minDate = startDate;
	if (stopDate) startOpt.maxDate = stopDate;
}
function setDrugDateOption() {
	var beginDate=$("#beginDate").datebox('getValue'),endDate=$("#endDate").datebox('getValue');
	var startOpt=$("#beginDate").datebox('options'),stopOpt=$("#endDate").datebox('options');
	if (beginDate) stopOpt.minDate = beginDate;
	if (endDate) startOpt.maxDate = endDate;
}
function updateDomSize() {
	var innerHeight=window.innerHeight;
  $('#patientList').panel('resize', {
  	height:innerHeight-('lite'==HISUIStyleCode?107:109)
  });
	$('#eduRecordTable').datagrid('resize',{
		height:innerHeight-(IsShowPatInfoBannner?49:8)
  })
}
window.addEventListener("resize",updateDomSize)
