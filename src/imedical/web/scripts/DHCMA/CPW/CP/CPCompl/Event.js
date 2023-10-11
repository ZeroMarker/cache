//页面Event
function InitHISUIWinEvent(obj){	
	//事件绑定
	obj.LoadEvents = function(arguments){
		
		// 合并症刷新
		$("#btnRefresh").on('click',function(){
			obj.RefreshComplGrid();	
		})
		
	};
	
	//刷新数据
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
	
	//勾选/取消勾选记录
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
				$.messager.popover({ msg: $g("操作失败，请重试！"), type: 'error' });
				return false;
			}else{
				$.messager.popover({ msg: $g("操作成功"), type: 'success' });
				$('#gridCompl').datagrid('reload');
				return true;
			}
		})	
	}
	
	// 预览表单内容
	obj.ViewForm = function(formID){
		//表单预览弹窗		
		websys_showModal({
			url:"./dhcma.cpw.bt.viewform.csp?1=1" +"&PathFormID=" + formID  ,
			title:$g("表单预览"),
			iconCls:'icon-w-eye',  
			closable:true,
			originWindow:window,
			width:'95%',
			height:'90%'
		})
			
	}
		
}


