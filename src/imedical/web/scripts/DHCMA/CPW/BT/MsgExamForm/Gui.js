//ҳ��Gui
var obj = new Object();
function InitViewFromWin(){	
    var viewColumns = [];			//���������
    
    //��ǰ��˽�ɫ
   var retRole = $m({
		ClassName:"DHCMA.CPW.BTS.ApplyExamRecDtlSrv",
		MethodName:"GetRoleName",
		aRecDtlID:RecDtlID
	},false);
	obj.RoleName=retRole.split("^")[0];			//��˽�ɫ
	obj.ExamResult=retRole.split("^")[1];		//��˽��
	obj.ExamOpinion=retRole.split("^")[2];		//������
	$("#txtOpinion").val(obj.ExamOpinion);
	
	
    
    //��ǰ��·��
    $cm({
		ClassName:"DHCMA.CPW.BT.PathForm",
		MethodName:"GetObjById",
		aId:PathFormID
	},function(data){
		obj.CurrPathID=data.FormPathDr;
	});
    
    //����ҳ��
    $cm({
		ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
		QueryName:"QryPathFormEp",
		aPathFormDr:PathFormID,
		ResultSetType:"array",
	},function(rs){
		//��̬����б���
		for (var i=0;i<rs.length;i++){
			var tmpObj = rs[i];
			viewColumns[i] = {field:"FLD-"+tmpObj.ID,title:tmpObj.EpDesc,styler:function(v,r,i){return 'position:relative;'}}
		}		
		$cm({
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			MethodName:"GetViewFormItems",
			aPathFormID:PathFormID
		},function(rs){
			$("#textDays").text(rs.days);
			$("#textCost").text(rs.cost);
			
			//��ȡ����ͼ
			obj.gridViewForm = $HUI.datagrid("#gridViewForm",{
				fit: true,
				title:'·�����ƣ�<span style=\"color:#1584D2\"><b>'+rs.name+'<b/></span><a id=\"imgEditPath\" title=\"�鿴·����Ϣ\" class=\"hisui-linkbutton\" onclick=obj.showPathInfoDiag() data-options=\"iconCls:\'icon-write-order\',plain:true\"></a><span style="float:right;font-weight:normal">��˽�ɫ��'+obj.RoleName+'</span>',
				headerCls:'panel-header-white', //������ʹ����ɻ�ɫ
				pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
				rownumbers: false, //���Ϊtrue, ����ʾһ���к���
				singleSelect: false,
				autoRowHeight: true, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
				loadMsg:'���ݼ�����...',
				pageSize: 99,
				pageList : [20,50,100,200],
				data:rs,
			    frozenColumns: [[
		        	{ field: 'step', title: '����', width: 100,align:'right',styler: function (value, row, index) {
             			return 'background-color:#F4F6F5;';
          			}},
		        ]],
				columns:[viewColumns],
				onBeforeLoad: function (param) {
		            var firstLoad = $(this).attr("firstLoad");
		            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
		            {
		                $(this).attr("firstLoad","true");
		                return false;
		            }
		            return true;
				},
				onLoadSuccess:function(){
					$(this).prev().find('div.datagrid-body').unbind('mouseover');
					$("input:not(:text)").attr("disabled", "disabled");  
					
					if (obj.ExamResult!="-1"){			// ����˱���ȴ������ݼ��سɹ������ð�ť������
						$("#btnPass").linkbutton("disable")
						$("#btnNoPass").linkbutton("disable")
					}
					$.parser.parse();
				},
				onClickRow: function (rowIndex, rowData) {
    				$(this).datagrid('unselectRow', rowIndex);
				}
				,
				rowStyler: function(index,row){
					return 'background-color:#F7FBFF;';
				},
				loadFilter:function(data){
					//console.log(data)
					for(var key in data.rows[2]){
						if(key=="step") continue; 
						data.rows[2][key]="<img id='img-"+key.split('-')[1]+"'  class='imgLnkOrds' title='�鿴����ҽ��' onclick=obj.ViewLnkOrds(this.id) style='cursor:pointer;padding:10px;position:absolute;top:5px;right:5px;' src='../scripts_lib/hisui-0.1.0/dist/css/icons/template.png'></img></br>"+data.rows[2][key];
					}
					return data;		
				}
			});
		})
	})
	
	//�׶�ҽ����ϸ
	obj.gridOrders = $HUI.datagrid("#gridOrders",{
		fit: true,
		//height:400,
		showGroup: true,
		groupField:'ItemDesc',
		checkOnSelect:false,
		view: groupview,
		groupFormatter:function(value, rows){
			if(rows==undefined) return;
			if(value==undefined) return;
				return value + ' , ��( ' + rows.length + ' )��';
			},
		scrollbarSize: 0,
		checkOnSelect: true,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: false,
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',
		pageSize: 50,
		pageList : [50,100,150,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrdAll",
			aPathFormEpDr:"",
			aPathFormEpItemDr:"",
			aHospID:"",
			aOrdDesc:"",
			aOrdGroupID:"",
			page:1,
			rows:9999
	    },
		columns:[[
			{field:'checkOrd',checkbox:true,hidden:true,align:'center',width:'',auto:false},
			{field:'OrdMastIDDesc',title:'ҽ����',width:'300'
				,formatter: function(value,row,index){
					var FormOrdID=row['xID']
					if (FormOrdID.indexOf("FJ")>-1) {
						var FJid=FormOrdID.split(':')[1];
						FormOrdID=FormOrdID.split(':')[2]+"||"+FormOrdID.split(':')[1];
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return value+chkPosDesc+"<label id= 'pop"+FJid+"' style='color:red;' onmouseover=obj.ShowFJDetail("+FJid+") onmouseout=obj.DestoryFJDetail("+FJid+")>[��ϸ]</label>"
					}else if(row['OrdMastID'].split("||").length!=2){
						var ARCOSRowid=row['OrdMastID'];
						var ARCOSDesc=row['OrdMastIDDesc'];
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return "<span id='"+id+"'>"+value+chkPosDesc+"</span><label style='color:red;cursor:pointer;' onclick=ShowARCOSDetail('"+ARCOSRowid+"')>[��ϸ]</label>"
					}else{
						var id=FormOrdID.split("||").join("-");
						var chkPosDesc=row['OrdChkPosID'].split("||")[0];
						return "<span id='"+id+"' onclick=obj.ClickOrdDesc("+index+");>"+value+chkPosDesc+"</span>"
					}
				}
			},
			{field:'OrdLnkOrdDr',title:'������',width:'50'},
			{field:'OrdDoseQty',title:'���μ���',width:'70'},
			{field:'OrdUOMIDDesc',title:'��λ',width:'70'},
			{field:'OrdFreqIDDesc',title:'Ƶ��',width:'70'},
			{field:'OrdInstrucIDDesc',title:'�÷�',width:'70'},
			{field:'OrdDuratIDDesc',title:'�Ƴ�',width:'70'},
			{field:'OrdQty',title:'����',width:'60'},
			{field:'OrdIsDefault',title:'��ѡҽ��',width:'70'},
			{field:'OrdIsFluInfu',title:'��ҽ��',width:'70'},
			{field:'OrdTypeDrDesc',title:'������',width:'70'},
			{field:'OrdPriorityIDDesc',title:'ҽ������',width:'70'},
			{field:'OrdNote',title:'��ע',width:'70'}
		]]
	})
	
	//ҽ����ϸ������ʼ��
	$('#winViewLnkOrds').dialog({
		title: '����ҽ����ϸ',
		iconCls:"icon-w-paper",
		closed: true,
		modal: true,
		isTopZindex:true,
		width:'1200',
		height:'500'
	});
	
	//ҽ����ҽ���б�
  	obj.gridARCOSOrder = $HUI.datagrid("#gridARCOSOrder",{
		fit: true,
		pagination: false, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		rownumbers: true, //���Ϊtrue, ����ʾһ���к���
		singleSelect: false,
		remoteSort:false,
		sortName:"SeqNo",
		sortOrder:"asc",
		autoRowHeight: false, //�����Ƿ����û��ڸ������ݵ��и߶ȡ�����Ϊ false���������߼�������
		loadMsg:'���ݼ�����...',   
		columns:[[
			{field:'ARCIMDesc',title:'ҽ������',width:'300'},
			{field:'DoseQty',title:'���μ���',width:'80'},
			{field:'DoseUOMDesc',title:'������λ',width:'80'},
			{field:'FreqDesc',title:'Ƶ��',width:'80'},
			{field:'InstrDesc',title:'�÷�',width:'80'},
			{field:'DurDesc',title:'�Ƴ�',width:'80'},
			{field:'SeqNo',title:'���',width:'80'}	
		]],
		onBeforeLoad: function (param) {
	        var firstLoad = $(this).attr("firstLoad");
	        if (firstLoad == "false" || typeof (firstLoad) == "undefined")
	        {
	            $(this).attr("firstLoad","true");
	            return false;
	        }
	        return true;
		},
		rowStyler: function(index,row){
			var SeqNo=row.SeqNo;
			if (SeqNo=="") return;
			if (SeqNo.indexOf(".")>-1) return 'background-color:#cdf1cd;';
			else return 'background-color:#94e494;';						
		}
	});
	
	ShowARCOSDetail = function(ARCOSRowid){
		$('#gridARCOSOrder').datagrid('loadData',{rows:[],total:0});
		$cm({
			ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryOrderByARCOS",
			ARCOSRowid:ARCOSRowid,
			aHospID:session['DHCMA.HOSPID'],
			page:1,
			rows:99999
		},function(rs){
			$('#gridARCOSOrder').datagrid('loadData',rs);
			$('#ARCOSCPWDialog').dialog({title:"��ǰҽ����ϸ"});   
			$HUI.dialog('#ARCOSCPWDialog').open();
		})	
	}
	
	InitViewFormWinEvent(obj);
	obj.LoadEvents(arguments);
	$.parser.parse();
}