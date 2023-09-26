
//名称	DHCPEFindErrDetail.js
//组件	DHCPEFindErrDetail 	
//创建	2019.03.27
//创建人  xy
function DblClickRowHandler(index,rowdata)	{
	var objtbl = $("#tDHCPEFindErrDetail").datagrid('getRows');
	var ErrDetail=objtbl[index].ErrDetail;
	var ErrUserID=objtbl[index].UserID;
	var ErrUser=objtbl[index].UserName;
	var ExpStr=getValueById("ExpStr");
		
	if (window.parent){
		$("#ErrDetail",window.opener.document).val(ErrDetail);
			if ((ExpStr!="GA")&&(ExpStr!="GR")){
				$("#ErrUserID",window.opener.document).val(ErrUserID);
				$("#ErrUser",window.opener.document).val(ErrUser);
			
			}
		}	
	
}