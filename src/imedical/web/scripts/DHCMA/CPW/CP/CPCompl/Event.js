//ҳ��Event
function InitHISUIWinEvent(obj){	
	//�¼���
	obj.LoadEvents = function(arguments){
		
		// �ϲ�֢ˢ��
		$("#btnRefresh").on('click',function(){
			obj.RefreshComplGrid();	
		})
		
	};
	
	//ˢ������
	obj.RefreshComplGrid = function(){
		$("#txtSearch").searchbox("setValue","");
		
		$cm ({
			ClassName:"DHCMA.CPW.CPS.PathwayComplSrv",
			QueryName:"QryComplPathMast",
			ResultSetType:"array",
			aPathwayID:PathwayID,
			aKeyWord:"",
			aHospID:session['DHCMA.HOSPID'],
			aAdmType:"I",
			page:1,
			rows:99999
		},function(rs){
			$('#gridCompl').datagrid({sortName:"isChked",sortOrder:"desc",}).datagrid('loadData', rs);				
		});
		
	}
	
	//��ѡ/ȡ����ѡ��¼
	obj.CheckComplRec = function(index,isChked){
		var row = $('#gridCompl').datagrid('getRows')[index];
		var subPwComplID="";
		if (row.PwComplID) {
			subPwComplID=row.PwComplID.split("||")[1];	
		}
		var aInputStr=PathwayID +"^"+ subPwComplID +"^"+ row.ComplFormID +"^"+ row.PathComplID +"^"+ session['DHCMA.USERID'] +"^"+ isChked
		$m({
			ClassName:"DHCMA.CPW.CP.PathwayCompl",
			MethodName:"Update",
			aInputStr:aInputStr
		},function(data){
			if (parseInt(data)<0){
				$.messager.popover({ msg: $g("����ʧ�ܣ������ԣ�"), type: 'error' });
				return false;
			}else{
				$.messager.popover({ msg: $g("�����ɹ�"), type: 'success' });
				$('#gridCompl').datagrid('reload');
				return true;
			}
		})	
	}
	
	// Ԥ��������
	obj.ViewForm = function(formID){
		//��Ԥ������		
		websys_showModal({
			url:"./dhcma.cpw.bt.viewform.csp?1=1" +"&PathFormID=" + formID  ,
			title:$g("��Ԥ��"),
			iconCls:'icon-w-eye',  
			closable:true,
			originWindow:window,
			width:'95%',
			height:'90%'
		})
			
	}
		
}


