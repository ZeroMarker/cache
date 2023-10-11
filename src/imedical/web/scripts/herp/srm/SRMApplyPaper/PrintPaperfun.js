///////////////////////////////////////172.16.2.20
function printDetail(rs, path) {
	//alert(2)
	var xlApp, xlsheet, xlBook, arr;
	xlApp = new ActiveXObject("Excel.Application");
	//xlBook = xlApp.Workbooks.Add("http://172.16.2.20/trakcare/web/scripts/dhcdura/print/InStorage.xls");
	xlBook = xlApp.Workbooks.Add("http://localhost/DtHealth/app/dthis/web/scripts/herp/srm/SRMApplyPaper/print/InStorage.xls");
	xlsheet = xlBook.ActiveSheet;
	var arr = rs.split("#");
	var rowTotal = arr.length - 1;
	var title = arr[0].split("^");

	var printRowCount = 10

	var IOWNo = title[0] // ���ݺ�
	var WHouseName = title[1] // �ⷿ
	var MakeBillDate = title[2] // �Ƶ�����
	var SupplierName = title[3] // ��Ӧ��
	var InvoiceNo = title[4] // ��Ʊ��
	var MakeBillUser = title[5] // �Ƶ���
	var InvTypeName = title[6] // �������

	xlsheet.cells(1, 1).value = "�������" + InvTypeName;
	xlsheet.cells(2, 1).value = "���ݺţ�" + IOWNo;
	xlsheet.cells(2, 4).value = "�ⷿ���ƣ�" + WHouseName;
	xlsheet.cells(2, 7).value = "�Ƶ�����";
	xlsheet.cells(2, 8).value = "��" + MakeBillDate;
	xlsheet.cells(8, 1).value = SupplierName;

	var cols = 9
	var rows = 1
	var arri = 0
	var pageconut = 0
	var pageover = 0
	
	//ÿҳ��ӡ������
	var printRow = 10
	
	/*
	 * for(i=1;i<number;i++) { var str=arr[i].split("^"); for(j=0;j<cols;j++) {
	 * xlsheet.cells(i+3,j+1)=str[j]; } }
	 * 
	 */
	xlsheet.cells(printRowCount + 5, 8) = "�Ƶ���:" + MakeBillUser;

	if (rowTotal <= printRow) {
		printRow = rowTotal 
		for (i = 1; i <= printRow; i++) {
			arri = arri + 1
			var str = arr[arri].split("^");
			for (j = 0; j < cols; j++) {
				xlsheet.cells(i + 3, j + 1) = str[j];

			}
		}
			xlsheet.printout;
			//xlsheet.printout;
			//xlsheet.printout;
	//xlApp.Visible=true;
	//xlsheet.PrintPreview();//��ӡ��ҪԤ��
	
	} else {

		pageover = rowTotal % printRow
		pageconut = parseInt(rowTotal / printRow)

		for (n = 0; n < pageconut; n++) {
			for (i = 1; i <= printRow; i++) {
				arri = arri + 1
				var str = arr[arri].split("^");
				for (j = 0; j < cols; j++) {
					xlsheet.cells(i + 3, j + 1) = str[j];

				}
			}
			xlsheet.printout;
			//xlsheet.printout;
			//xlsheet.printout;
		}
		
		if(pageover>0)	{
			//��մ�ӡҳ��
			for (i = 1; i <= printRow; i++) {
				for (j = 0; j < cols; j++) {
					xlsheet.cells(i + 3, j + 1) = null;

				}
			}
			
			for (i = 1; i <= pageover; i++) {
				arri = arri + 1
				var str = arr[arri].split("^");
				for (j = 0; j < cols; j++) {
					xlsheet.cells(i + 3, j + 1) = str[j];

				}
			}
			xlsheet.printout ;
			//xlsheet.printout;
			//xlsheet.printout;
			
		}
	}
	//xlApp.Visible=true;
	//xlsheet.PrintPreview();//��ӡ��ҪԤ��
	
	xlsheet=null;
	xlBook.Close(savechanges = false);
	xlBook=null;
	
	xlApp.Quit();
}
function Print()
{
	var rowObj = itemGrid11111.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		//alert(1)
		if(len < 1)
		{
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��ӡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{

			tmpRowid = rowObj[0].get("rowid");				
			Ext.Ajax.request({
				url:'dhc.dura.yxinfowarehouserecdetailexe.csp?action=print&recMainDr='+tmpRowid,
				waitMsg:'��ӡ��...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success=='true') {
					vurl="C:\Documents and Settings\Administrator\����";
					str=jsonData.info;
					printDetail(str,vurl);
				}else{
					Ext.Msg.show({title:'����',msg:'����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
				scope: this
			});  
		}

}
