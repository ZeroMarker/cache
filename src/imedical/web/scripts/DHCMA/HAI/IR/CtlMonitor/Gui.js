//ҳ��Gui
var objScreen = new Object();
function InitCtlMonitorWin(){
	var obj = objScreen;

	// ���ڸ���ʼֵ
	var YearList = $cm ({									//��ʼ����(���ʮ��)
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryYear"
	},false);
	$HUI.combobox("#cboYear",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:YearList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//���Ŀ�ʼ-��������
		}
	});
	var MonthList = $cm ({									//��ʼ����+����+ȫ��
		ClassName:"DHCHAI.STATV2.AbstractComm",
		QueryName:"QryMonth"
	},false);
	$HUI.combobox("#cboMonth",{
		valueField:'ID',
		textField:'Desc',
		editable:false,
		data:MonthList.rows,
		onSelect:function(rec){
			Date_QuickSelect("cboYear","cboMonth","dtDateFrom","dtDateTo");	//���Ŀ�ʼ-��������
		}
	});
	var NowDate=month_formatter(new Date());
	var NowYear=NowDate.split("-")[0];	//��ǰ��
	var NowMonth=NowDate.split("-")[1]	//��ǰ��
	$('#cboYear').combobox('select',NowYear);
	$('#cboMonth').combobox('select',NowMonth);
	//ҽԺ
    $HUI.combobox("#cboHospital",{
		url:$URL+'?ClassName=DHCHAI.BTS.HospitalSrv&QueryName=QryHospListByLogon&ResultSetType=Array&aLogonHospID='+$.LOGON.HOSPID,
		valueField:'ID',
		textField:'HospDesc',
		editable:false,
		onSelect:function(rec){
			Common_ComboToLoc('cboLocation',rec.ID,"","I","W");
			Common_ComboToLoc('cboWard',rec.ID,"","I","W");
		},
		onLoadSuccess:function(data){
			// Ժ��Ĭ��ѡ��
			$('#cboHospital').combobox('select',data[0].ID);
		}
	});
	$HUI.combobox("#cboMRBOutLabType",{
		url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode=MRBOutLabType',
		allowNull: true,       //�ٴε��ȡ��ѡ��
		valueField:'ID',
		textField:'DicDesc'
	});
	$HUI.combobox("#cboDateType",{
		data:[
			{value:'1',text:'�ͼ�����',selected:true},
			{value:'2',text:'��������'}
		],
		valueField:'value',
		textField:'text'
	})
	///���ز�ԭ��
	$HUI.combobox("#cboBacteria",{
		url:$URL+'?ClassName=DHCHAI.DPS.LabBactSrv&QueryName=QryLabBacteria&ResultSetType=Array',
		allowNull: true,       //�ٴε��ȡ��ѡ��
		valueField:'ID',
		textField:'BacDesc'
	});
	///���ض�������
	$HUI.combobox("#cboMRBBact",{
		url:$URL+'?ClassName=DHCHAI.IRS.CRuleMRBSrv&QueryName=QryCRuleMRB&ResultSetType=Array',
		allowNull: true,       //�ٴε��ȡ��ѡ��
		valueField:'ID',
		textField:'BTDesc'
	});
	///���ر걾
	$HUI.combobox("#cboInfType",{
		url:$URL+'?ClassName=DHCHAI.BTS.DictionarySrv&QueryName=QryDic&ResultSetType=Array&aTypeCode=IRInfType&aActive=1',
		allowNull: true,       //�ٴε��ȡ��ѡ��
		valueField:'ID',
		textField:'DicDesc'
	});
	
	obj.gridCtlResult=$('#gridCtlResult').datagrid({
        fit:true,
        title:'������ҩ�����',
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
        rownumbers:true,
        singleSelect:false,
        autoRowHeight: true, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
        nowrap: false,
		loadMsg:'���ݼ�����...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
		sortOrder:'asc',
		remoteSort:false,
	    columns:[[
	        { field:"PapmiNo",title:"�ǼǺ�",width:100,sortable:true},
			{ field:"MrNo",title:"������",width:100,sortable:true},
			{ field:"PatName",title:"����",width:100,sortable:true},			
			{ field:"AdmWardDesc",title:"���ﲡ��",width:150,sortable:true},
			{ field:"MRBDesc",title:"��������",width:200,sortable:true,
				formatter: function(value,row,index){
					if (value){
					  	var strList = value.split(",");
					  	var len = strList.length;
					    var strRet ="";
					  	for (var indx=0;indx<len;indx++){
				            var MRBDesc =strList[indx];
					         strRet +=MRBDesc+"</br>";  	
					  	}
					  	return strRet;
				  	}else {
						return "";
				  	}
				}
			}, 
			{ field:"link",title:"��ϸ",width:80,sortable:true,
				formatter:function(value,row,index){
					 var EpisodeID=row["AdmID"];
					return '<a href="#" onclick="objScreen.openDetail(\'' + EpisodeID + '\')">��ϸ</a>';
				}
			},
			{ field:"SpecBact",title:"�걾 -> ϸ��",width:200,sortable:true,
				formatter: function(value,row,index){
					if (value){
					  	var strList = value.split(",");
					  	var len = strList.length;
					    var strRet ="";
					  	for (var indx=0;indx<len;indx++){
				            var SpecBact =strList[indx];
					         strRet +=SpecBact+"</br>";  	
					  	}
					  	return strRet;
				  	}else {
						return "";
				  	}
				}
			}, 
			{ field:"ZY",title:"ժҪ",width:80,
				formatter:function(value,row,index){					
					 return '<a href="#" onclick="objScreen.OpenMainView(\'' + row.AdmID + '\')">ժҪ</a>';
				}
			},
			{ field:"expander",title:"���Ӳ���",width:80,
				formatter:function(value,row,index){
					var EpisodeID = row["EpisodeID"];
					EpisodeID = EpisodeID.split("||")[1];
					return '<a href="#" onclick=objScreen.OpenEmrRecord(\''+EpisodeID+'\',\''+row.PatientID+'\')>�������</a>';
				}
			},
			{ field:"Sex",title:"�Ա�",width:50,sortable:true},
			{ field:"Age",title:"����",width:80,sortable:false},
			{ field:"AdmDate",title:"��Ժ����",width:100,sortable:true,sorter:Sort_int},
			{ field:"DischDate",title:"��Ժ����",width:100,sortable:true,sorter:Sort_int}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
			$(this).datagrid('columnMoving'); //�п�����ק�ı�˳��
		}
    });
	obj.gridBactDetail=$('#gridBactDetail').datagrid({
        fit:true,
        headerCls:'panel-header-gray',
		iconCls:'icon-resort',
        pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
        rownumbers:false,
		nowrap:true,
		fitColumns: true,
        singleSelect:false,
        autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		loading:true,
		pageSize: 20,
		pageList : [20,50,100,200],
	    columns:[[
	        { field:"ID",title:"���",width:50},
			{ field:"Specimen",title:"�걾",width:100,showTip:true},
			{ field:"Bacteria",title:"ϸ��",width:170,showTip:true},
			{ field:"MRBDesc",title:"��������",width:200,showTip:true},
			{ field:"ActDate",title:"�ͼ�����",width:100},
			{ field:"RepDate",title:"��������",width:100},
			{ field:"ActLocDesc",title:"����",width:120,showTip:true},
			{ field:"ActUser",title:"ҽ��",width:100}
		]],
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //����Ч��
		}
    });

	InitCtlMonitorWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
