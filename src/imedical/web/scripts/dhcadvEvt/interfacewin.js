/// Description: �����¼��ӿڴ��ڣ�portal��ʹ�ý��벻���¼�����
/// Creator: congyue
/// CreateDate: 2019-01-07
$(document).ready(function(){
	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.layoutform.csp?recordId='+recordId+'&RepStaus='+RepStaus+'&RepTypeDr='+RepTypeDr+'&code='+RepTypeCode+'&desc='+RepType+'&RepID='+RepID+'&editFlag='+editFlag+'&adrReceive='+adrReceive+'&RepStausDr='+RepStausDr+'&StatusNextID='+StatusNextID+'&FileFlag='+FileFlag+'&StsusGrant='+StsusGrant+'&StatusLastID='+StatusLastID+'&StaFistAuditUser='+StaFistAuditUser+'&UserLeadflag='+UserLeadflag+'&RepAppAuditFlag='+RepAppAuditFlag+'&StatusNext='+StatusNext+'&winflag='+winflag+'&WinUserId='+WinUserId+'&WinLocId='+WinLocId+'&WinGroupId='+WinGroupId+'"></iframe>';
	$('#interfacewin').html(iframe);

});