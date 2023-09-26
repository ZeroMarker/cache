function BodyLoadHandler()
{
	document.body.style.padding="8px";
	document.body.style.paddingTop="0px";
	$('#tUDHCACFinBR_PFDeposit_Cashier').datagrid({
		striped:true,
		onLoadSuccess:function(data){
			if(data.rows.length>1){
				setValueById('StTime',data.rows[1].StTime);
				setValueById('EndTime',data.rows[1].EndTime);
			}
		}
	})
	
}


document.body.onload = BodyLoadHandler;