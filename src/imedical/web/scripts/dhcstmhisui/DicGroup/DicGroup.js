// /名称: 字典安全组授权
// /描述: 字典安全组授权
// /编写者：zhangxiao
// /编写日期: 2018.09.20
var init = function() {
	var GroupBox = $HUI.combobox('#Group', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetGroup&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
	});
	$('#Group').combobox({
	onChange: function (TGroupId,FGroupId) {
			//FGroupId 原来的安全组id ,TGroupId改变后的安全组id
		   Query(TGroupId);
		}
	});
	
	var Query=function(TGroupId){
		$.cm({
				ClassName: 'web.DHCSTMHUI.DicGroup',
				MethodName: 'LoadData',
				DGGroupDR:TGroupId
			},
			function(jsonData){
				if(jsonData.success!=0){
					$UI.msg('error',jsonData.msg);
				}else{
					$UI.clearBlock('#InciData');
					$UI.clearBlock("#PhamnfData");
					$UI.clearBlock("#VendorData");
					$UI.fillBlock('#InciData',jsonData.Data);
					$UI.fillBlock('#PhamnfData',jsonData.Data);
					$UI.fillBlock('#VendorData',jsonData.Data);
			
				}
			});	
		
	}
	var ClearMain=function(){
		$UI.clearBlock("#InciData");
		$UI.clearBlock("#PhamnfData");
		$UI.clearBlock("#VendorData");
		$UI.clearBlock('#DicGroupTB');
	}	
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			ClearMain();
		}
	});
	var InciDataChose=function(){
		$HUI.checkbox('#DGCode').setValue(true);
		$HUI.checkbox('#DGDesc').setValue(true);
		$HUI.checkbox('#DGChargeType').setValue(true);
		$HUI.checkbox('#DGSp').setValue(true);
		$HUI.checkbox('#DGPbRp').setValue(true);
		$HUI.checkbox('#DGSpec').setValue(true);
		$HUI.checkbox('#DGScg').setValue(true);
		$HUI.checkbox('#DGStkcat').setValue(true);
		$HUI.checkbox('#DGBrand').setValue(true);
		
		$HUI.checkbox('#DGUom').setValue(true);
		$HUI.checkbox('#DGPbManf').setValue(true);
		$HUI.checkbox('#DGPbVendor').setValue(true);
		$HUI.checkbox('#DGHVFlag').setValue(true);
		$HUI.checkbox('#DGCertNo').setValue(true);
		$HUI.checkbox('#DGProvLoc').setValue(true);
		$HUI.checkbox('#DGPruPic').setValue(true);
		$HUI.checkbox('#DGPruCommonPic').setValue(true);
		$HUI.checkbox('#DGPruDocumentPic').setValue(true);
		
		$HUI.checkbox('#DGItmSA').setValue(true);
		$HUI.checkbox('#DGHospAllowed').setValue(true);
	}	
	$UI.linkbutton('#InciDataChoseBT',{
		onClick:function(){
			InciDataChose();
		}
	});
	
	var PhanfChose=function(){
		$HUI.checkbox('#DGMCert').setValue(true);
		$HUI.checkbox('#DGMMatProduct').setValue(true);
		$HUI.checkbox('#DGMComLic').setValue(true);
		$HUI.checkbox('#DGMBusinessReg').setValue(true);
		$HUI.checkbox('#DGMOrgCode').setValue(true);
		$HUI.checkbox('#DGMMatManLic').setValue(true);
		
	}
	$UI.linkbutton('#PhanfChoseBT',{
		onClick:function(){
			PhanfChose();
		}
	});
	function VendorChose(){
		$HUI.checkbox('#DGVLic').setValue(true);
		$HUI.checkbox('#DGVComlic').setValue(true);
		$HUI.checkbox('#DGVRevreg').setValue(true);
		$HUI.checkbox('#DGVMatmanlic').setValue(true);
		$HUI.checkbox('#DGVMatenrol').setValue(true);
		$HUI.checkbox('#DGVSanitation').setValue(true);
		$HUI.checkbox('#DGVOrgcode').setValue(true);
		$HUI.checkbox('#DGVGsp').setValue(true);
		
		$HUI.checkbox('#DGVMatpro').setValue(true);
		$HUI.checkbox('#DGVPropermit').setValue(true);
		$HUI.checkbox('#DGVQuality').setValue(true);
		$HUI.checkbox('#DGVSales').setValue(true);
	}
	$UI.linkbutton('#VendorChoseBT',{
		onClick:function(){
			VendorChose();
		}
	});
	
	$UI.linkbutton('#SaveBT',{
			onClick:function(){
			Save();
			}
	});
	var Save =function(){
		var MainObj=$UI.loopBlock('#DicGroupTB')
		if(isEmpty(MainObj.Group)){
				$UI.msg('alert','安全组不能为空!')
				return;
			}	
		var GroupId=MainObj.Group
		
		var InciObj=$UI.loopBlock('#InciData')
		var IncData=JSON.stringify(InciObj)
		
		var PhamnfObj=$UI.loopBlock('#PhamnfData')
		var PhamnfData=JSON.stringify(PhamnfObj)
		
		var VendorObj=$UI.loopBlock('#VendorData')
		var VendorData=JSON.stringify(VendorObj)
		
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DicGroup',
			MethodName: 'Save',
			GroupId: GroupId,
			IncData: IncData,
			PhamnfData: PhamnfData,
			VendorData: VendorData
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				var MainObj=$UI.loopBlock('#DicGroupTB')
				Query(MainObj.Group)
			}else{
				$UI.msg('error',jsonData.msg);		
			}
		});	
		
	}
	
	
	
}
$(init);