function InitFPMainInfo(obj){
    obj.FPM_InitView = function(){
		obj.FPM_Editor = new Object();
		obj.arryFPMData = new Array();
		obj.FPM_Editor.Items = new Array();
		var ret=obj.FPM_LoadFPQuery();
		
		obj.FPM_FPTemplate.overwrite("divMainIfno-FP",obj.arryFPMData);
		obj.FPS_FPTemplate.overwrite("divSubIfno-FP",obj.arryFPMData);
		obj.FPM_CreatEditorItems(obj.arryFPMData);  //����������Ŀ�༭��Ԫ
	}
	
	obj.FPM_LoadFPQuery = function(){
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.FP.ExtraItem'
		url += '&QueryName=' + 'QryExtraItem'
		url += '&ArgCnt=' + 0
		url += '&2=2'
		conn.open('post',url,false);
		conn.send(null);
		
		if (conn.status != '200') {
			ExtTool.alert('����', '��ѯQuery����1!');
			return false;
		}
		
		var jsonData = new Ext.decode(conn.responseText);
		if (jsonData.total < 1){
			ExtTool.alert('��ѯQuery����2!');
			return false;
		} else {
			var arryData = new Array();
			var objItem = null;
			for (var row = 0; row < jsonData.record.length; row++){
				objItem = jsonData.record[row];
				arryData[arryData.length] = objItem;
			}
			obj.arryFPMData.length = 0;
			obj.arryFPMData = arryData;
				
			return true;
		}
		
	/* 	Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCWMR.FP.ExtraItem',
				QueryName : 'QryExtraItem',
				ArgCnt : 0
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				var arryData = new Array();
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					if (objItem.ItemCode.indexOf("FPM")>-1) arryData[arryData.length] = objItem;
				}
				obj.arryFPMData.length = 0;
				obj.arryFPMData = arryData;
				
				return true;
				
			},
			failure: function(response, opts) {
				ExtTool.alert("��ʾ","��Ҫ������Ϣ���ش���!");
				return false;
			}
		}); */
	}
	
	obj.FPM_FPTemplate = new Ext.XTemplate(
		'<table id="tableMainInfo_FP" border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;width:100%;">',
			'<tbody>',
				'<tr><td width="100%"><div style="width=100%;padding:0px 10px;">',
					'<table><tr>',
						'<td><div class="TD-title">ҽ�Ƹ��ѷ�ʽ</div></td><td><div class="TD-content" {[this.divStyle("P00020000")]}></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">��������</div></td><td><div class="TD-content" {[this.divStyle("P00030000")]}></div></td>',
						'<td><div class="TD-title">סԺ����</div></td><td><div class="TD-content" {[this.divStyle("P00040000")]}></div></td>',
						'<td><div class="TD-title">������</div></td><td><div class="TD-content" {[this.divStyle("P00050000")]}></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">����</div></td><td><div class="TD-content" {[this.divStyle("P00060000")]}></div></td>',
						'<td><div class="TD-title">�Ա�</div></td><td><div class="TD-content" {[this.divStyle("P00070000")]}></div></td>',
						'<td><div class="TD-title">��������</div></td><td><div class="TD-content" {[this.divStyle("P00080000")]}></div></td>',
						'<td><div class="TD-title">����</div></td><td><div class="TD-content" {[this.divStyle("P00090000")]}></div></td>',
						'<td><div class="TD-title">����</div></td><td><div class="TD-content" {[this.divStyle("P00100000")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">����(����1����)</div></td><td><div class="TD-content" {[this.divStyle("P00090100")]}></div></td>',
						'<td><div class="TD-title">��������������</div></td><td><div class="TD-content" {[this.divStyle("P00110000")]}></div></td>',
						'<td><div class="TD-title">��������Ժ����</div></td><td><div class="TD-content" {[this.divStyle("P00120000")]}></div></td>',
						'<td><div class="TD-title" style="text-align:left;">(���ص�λ����)</div></td><td><div class="TD-content" ></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">�����أ�ʡ</div></td><td><div class="TD-content" {[this.divStyle("P00130100")]}></div></td>',
						'<td><div class="TD-title">��(��������)</div></td><td><div class="TD-content" {[this.divStyle("P00130200")]}></div></td>',
						'<td><div class="TD-title">��(��)</div></td><td><div class="TD-content" {[this.divStyle("P00130300")]}></div></td>',
						'<td><div class="TD-title">���᣺ʡ</div></td><td><div class="TD-content" {[this.divStyle("P00140100")]}></div></td>',
						'<td><div class="TD-title">��(��������)</div></td><td><div class="TD-content" {[this.divStyle("P00140200")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">����</div></td><td><div class="TD-content" {[this.divStyle("P00150000")]}></div></td>',
						'<td><div class="TD-title">���֤��</div></td><td><div class="TD-content" {[this.divStyle("P00160000")]}></div></td>',
						'<td><div class="TD-title">ְҵ</div></td><td><div class="TD-content" {[this.divStyle("P00170000")]}></div></td>',
						'<td><div class="TD-title">����</div></td><td><div class="TD-content" {[this.divStyle("P00180000")]}></div></td>',
						'<td><div class="TD-title">�绰</div></td><td><div class="TD-content" {[this.divStyle("P00190500")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">��סַ��ʡ</div></td><td><div class="TD-content" {[this.divStyle("P00190100")]}></div></td>',
						'<td><div class="TD-title">��(��������)</div></td><td><div class="TD-content" {[this.divStyle("P00190200")]}></div></td>',
						'<td><div class="TD-title">��(��)</div></td><td><div class="TD-content" {[this.divStyle("P00190300")]}></div></td>',
						'<td><div class="TD-title">��ϸ</div></td><td><div class="TD-content" {[this.divStyle("P00190400")]}></div></td>',
						'<td><div class="TD-title">��������</div></td><td><div class="TD-content" {[this.divStyle("P00190600")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">���ڵ�ַ��ʡ</div></td><td><div class="TD-content" {[this.divStyle("P00200100")]}></div></td>',
						'<td><div class="TD-title">��(��������)</div></td><td><div class="TD-content" {[this.divStyle("P00200200")]}></div></td>',
						'<td><div class="TD-title">��(��)</div></td><td><div class="TD-content" {[this.divStyle("P00200300")]}></div></td>',
						'<td><div class="TD-title">��ϸ</div></td><td><div class="TD-content" {[this.divStyle("P00200400")]}></div></td>',
						'<td><div class="TD-title">��������</div></td><td><div class="TD-content" {[this.divStyle("P00200500")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">������λ����ַ</div></td><td><div class="TD-Longcontent" {[this.divStyle("P00210000")]}></div></td>',
						'<td><div class="TD-title">�绰</div></td><td><div class="TD-content" {[this.divStyle("P00210100")]}></div></td>',
						'<td><div class="TD-title">��������</div></td><td><div class="TD-content" {[this.divStyle("P00210200")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">��ϵ������</div></td><td><div class="TD-content" {[this.divStyle("P00220000")]}></div></td>',
						'<td><div class="TD-title">�뻼�߹�ϵ</div></td><td><div class="TD-content" {[this.divStyle("P00220100")]}></div></td>',
						'<td><div class="TD-title">��ַ</div></td><td><div class="TD-content" {[this.divStyle("P00220200")]}></div></td>',
						'<td><div class="TD-title">�绰</div></td><td><div class="TD-content" {[this.divStyle("P00220300")]}></div></td>',
						'<td><div class="TD-title">��Ժ;��</div></td><td><div class="TD-content" {[this.divStyle("P00230000")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">��Ժ����</div></td><td><div class="TD-content" {[this.divStyle("P00250000")]}></div></td>',
						'<td><div class="TD-title">��Ժ�Ʊ�</div></td><td><div class="TD-content" {[this.divStyle("P00260000")]}></div></td>',
						'<td><div class="TD-title">����</div></td><td><div class="TD-content" {[this.divStyle("P00270000")]}></div></td>',
						'<td><div class="TD-title">ת��</div></td><td><div class="TD-content" {[this.divStyle("P00280000")]}></div></td>',
						'<td><div class="TD-title">Ѫ��</div></td><td><div class="TD-content" {[this.divStyle("P00570000")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">��Ժ����</div></td><td><div class="TD-content" {[this.divStyle("P00290000")]}></div></td>',
						'<td><div class="TD-title">��Ժ�Ʊ�</div></td><td><div class="TD-content" {[this.divStyle("P00300000")]}></div></td>',
						'<td><div class="TD-title">����</div></td><td><div class="TD-content" {[this.divStyle("P00310000")]}></div></td>',
						'<td><div class="TD-title">סԺ����</div></td><td><div class="TD-content" {[this.divStyle("P00320000")]}></div></td>',
						'<td><div class="TD-title">Rh</div></td><td><div class="TD-content" {[this.divStyle("P00580000")]}></div></td>',
					'</tr></table>',
					 '<table><tr>',
						'<td><div class="TD-title">�Ƿ�ҩ�����</div></td><td><div class="TD-content" {[this.divStyle("P00510000")]}></div></td>',
						'<td><div class="TD-title">����ҩ��</div></td><td><div class="TD-Longcontent" {[this.divStyle("P00520000")]}></div></td>',
						'<td><div class="TD-title">��������ʬ��</div></td><td><div class="TD-content" {[this.divStyle("P00530000")]}></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">������</div></td><td><div class="TD-content" {[this.divStyle("P00600100")]}></div></td>',
						'<td><div class="TD-title">(��)����ҽʦ</div></td><td><div class="TD-content" {[this.divStyle("P00600200")]}></div></td>',
						'<td><div class="TD-title">����ҽʦ</div></td><td><div class="TD-content" {[this.divStyle("P00600300")]}></div></td>',
						'<td><div class="TD-title">סԺҽʦ</div></td><td><div class="TD-content" {[this.divStyle("P00600400")]}></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">���λ�ʿ</div></td><td><div class="TD-content" {[this.divStyle("P00600500")]}></div></td>',
						'<td><div class="TD-title">����ҽʦ</div></td><td><div class="TD-content" {[this.divStyle("P00600600")]}></div></td>',
						'<td><div class="TD-title">ʵϰҽʦ</div></td><td><div class="TD-content" {[this.divStyle("P00600800")]}></div></td>',
						'<td><div class="TD-title">����Ա</div></td><td><div class="TD-content" {[this.divStyle("P00600900")]}></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">��������</div></td><td><div class="TD-content" {[this.divStyle("P00610000")]}></div></td>',
						'<td><div class="TD-title">�ʿ�ҽʦ</div></td><td><div class="TD-content" {[this.divStyle("P00610100")]}></div></td>',
						'<td><div class="TD-title">�ʿػ�ʿ</div></td><td><div class="TD-content" {[this.divStyle("P00610200")]}></div></td>',
						'<td><div class="TD-title">����</div></td><td><div class="TD-content" {[this.divStyle("P00610300")]}></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>', 
					'<table><tr>',
						'<td><div class="TD-title">��Ժ��ʽ</div></td><td><div class="TD-content" {[this.divStyle("P00620000")]}></div></td>',
						'<td><div class="TD-title">ת��ҽ�ƻ���</div></td><td><div class="TD-content" {[this.divStyle("P00620100")]}></div></td>',
						'<td><div class="TD-title">������������</div></td><td><div class="TD-content" {[this.divStyle("P00620200")]}></div></td>',
						'<td><div class="TD-title">31������סԺ</div></td><td><div class="TD-content" {[this.divStyle("P00630000")]}></div></td>',
						'<td><div class="TD-title">Ŀ��</div></td><td><div class="TD-content" {[this.divStyle("P00630100")]}></div></td>',
					'</tr></table>', 
					'<table><tr>',
						'<td><div class="TD-title">��­������Ժǰ</div></td><td><div class="TD-content1" {[this.divStyle("P00640001")]}></div></td>',
						'<td><div class="TD-title1">��</div></td><td><div class="TD-content1" {[this.divStyle("P00640002")]}></div></td>',
						'<td><div class="TD-title1">Сʱ</div></td><td><div class="TD-content1" {[this.divStyle("P00640003")]}></div></td>',
						'<td><div class="TD-title1">����</div></td><td><div class="TD-content" ></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>',
					'<table><tr>',
						'<td><div class="TD-title">��­������Ժ��</div></td><td><div class="TD-content1" {[this.divStyle("P00650001")]}></div></td>',
						'<td><div class="TD-title1">��</div></td><td><div class="TD-content1" {[this.divStyle("P00650002")]}></div></td>',
						'<td><div class="TD-title1">Сʱ</div></td><td><div class="TD-content1" {[this.divStyle("P00650003")]}></div></td>',
						'<td><div class="TD-title1">����</div></td><td><div class="TD-content" ></div></td>',
						'<td><div class="TD-title"></div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>',
				'</div></td></tr>',	
			'</tbody>',
		'</table>',
		{
			divStyle : function(ItemCode){
				var tabEv = ''
				tabEv += ' id="Cmp_' + 'FPM_Editor_Item' + ItemCode + '"'
				//tabEv += ' style="width:100%;overflow:hidden;"'
				return tabEv;
			}
		}
	);
	
	
	obj.FPS_FPTemplate = new Ext.XTemplate(
		'<table id="tableSubInfo_FP" border=0 cellpadding=0 cellspacing=0 style="border-collapse:collapse;color:#457294;text-align:center;width:100%;">',
			'<tbody>',
				'<tr><td width="100%"><div style="width=100%;padding:0px 10px;">',
					 '<table><tr>',
						'<td><div class="TD-title">��������</div></td><td><div class="TD-content" {[this.divStyle("P90010000")]}></div></td>',
						'<td><div class="TD-title">ҽԺ��Ⱦ</div></td><td><div class="TD-content" {[this.divStyle("P90051000")]}></div></td>',
						'<td><div class="TD-title">��Ⱦ����</div></td><td><div class="TD-Longcontent" {[this.divStyle("P90052000")]}></div></td>',
						'<td><div class="TD-title">��Ⱦ���ϱ�</div></td><td><div class="TD-content" {[this.divStyle("P90130000")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">��Ѫ��Ӧ</div></td><td><div class="TD-content" {[this.divStyle("P00590000")]}></div></td>',
						'<td><div class="TD-title">��ϸ��(��λ)</div></td><td><div class="TD-content" {[this.divStyle("P00590100")]}></div></td>',
						'<td><div class="TD-title">ѪС��(��)</div></td><td><div class="TD-content" {[this.divStyle("P00590200")]}></div></td>',
						'<td><div class="TD-title">Ѫ��(ml)</div></td><td><div class="TD-content" {[this.divStyle("P00590300")]}></div></td>',
						'<td><div class="TD-title">�������(ml)</div></td><td><div class="TD-content" {[this.divStyle("P00590600")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">ȫѪ(ml)</div></td><td><div class="TD-content" {[this.divStyle("P00590400")]}></div></td>',
						'<td><div class="TD-title">����(ml)</div></td><td><div class="TD-content" {[this.divStyle("P00590500")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">���������Ϣ</span></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">�������ڣ�T</div></td><td><div class="TD-content" {[this.divStyle("P00680101")]}></div></td>',
						'<td><div class="TD-title">N</div></td><td><div class="TD-content" {[this.divStyle("P00680102")]}></div></td>',
						'<td><div class="TD-title">M</div></td><td><div class="TD-content" {[this.divStyle("P00680103")]}></div></td>',
						'<td><div class="TD-title2">(0:0��,1:����,2:����,3:����,4:����,5:����)</div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">���ȡ��ٴ�·����Ϣ</span></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">���ȴ���</div></td><td><div class="TD-content" {[this.divStyle("P00490000")]}></div></td>',
						'<td><div class="TD-title">�ɹ�����</div></td><td><div class="TD-content" {[this.divStyle("P00500000")]}></div></td>',
						'<td><div class="TD-title">�ٴ�·��</div></td><td><div class="TD-content" {[this.divStyle("P90080000")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">��֢�໤��Ϣ</span></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">��֢�໤����1</div></td><td><div class="TD-content" {[this.divStyle("P50010100")]}></div></td>',
						'<td><div class="TD-title">����ʱ��1</div></td><td><div class="TD-content" {[this.divStyle("P50010200")]}></div></td>',
						'<td><div class="TD-title">����ʱ��1</div></td><td><div class="TD-content" {[this.divStyle("P50010300")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">��֢�໤����2</div></td><td><div class="TD-content" {[this.divStyle("P50020100")]}></div></td>',
						'<td><div class="TD-title">����ʱ��2</div></td><td><div class="TD-content" {[this.divStyle("P50020200")]}></div></td>',
						'<td><div class="TD-title">����ʱ��2</div></td><td><div class="TD-content" {[this.divStyle("P50020300")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">��֢�໤����3</div></td><td><div class="TD-content" {[this.divStyle("P50030100")]}></div></td>',
						'<td><div class="TD-title">����ʱ��3</div></td><td><div class="TD-content" {[this.divStyle("P50030200")]}></div></td>',
						'<td><div class="TD-title">����ʱ��3</div></td><td><div class="TD-content" {[this.divStyle("P50030300")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">�Ƿ�ʹ�ú�����</div></td><td><div class="TD-content" {[this.divStyle("P90120000")]}></div></td>',
						'<td><div class="TD-title">ʹ��ʱ��</div></td><td><div class="TD-content" {[this.divStyle("P00670001")]}></div></td>',
						'<td><div class="TD-title">��Ժ��������</div></td><td><div class="TD-content" {[this.divStyle("P90230000")]}></div></td>',
						'<td><div class="TD-title">��ԺԺ��������</div></td><td><div class="TD-content" {[this.divStyle("P90240000")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">��������̥��Ϣ</span></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">��������������1</div></td><td><div class="TD-content" {[this.divStyle("P00110100")]}></div></td>',
						'<td><div class="TD-title">��������������2</div></td><td><div class="TD-content" {[this.divStyle("P00110200")]}></div></td>',
						'<td><div class="TD-title">��������������3</div></td><td><div class="TD-content" {[this.divStyle("P00110300")]}></div></td>',
						'<td><div class="TD-title" style="text-align:left;">(���ص�λ����)</div></td><td><div class="TD-content" ></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">��Ϸ������</span></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">��Ժʱ���</div></td><td><div class="TD-content" {[this.divStyle("P00380000")]}></div></td>',
						'<td><div class="TD-title">�������Ժ</div></td><td><div class="TD-content" {[this.divStyle("P00440000")]}></div></td>',
						'<td><div class="TD-title">��Ժ���Ժ</div></td><td><div class="TD-content" {[this.divStyle("P00450000")]}></div></td>',
						'<td><div class="TD-title">��ǰ������</div></td><td><div class="TD-content" {[this.divStyle("P00460000")]}></div></td>',
						'<td><div class="TD-title">�ٴ��벡��</div></td><td><div class="TD-content" {[this.divStyle("P00470000")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">ͬһ������Ժ</span></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">ȷ������</div></td><td><div class="TD-content" {[this.divStyle("P00390000")]}></div></td>',
						'<td><div class="TD-title">�Ƿ�15����</div></td><td><div class="TD-content" {[this.divStyle("P90140000")]}></div></td>',
						'<td><div class="TD-title">�Ƿ�30����</div></td><td><div class="TD-content" {[this.divStyle("P90150000")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td style="color:#000000;text-align:left;background-color:#84C1FF;width:100%;"><div style="width=100%;"><span style="font-size:16px;">����������Ϣ</span></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">��������1</div></td><td><div class="TD-content" {[this.divStyle("P90160600")]}></div></td>',
						'<td><div class="TD-title">�������1</div></td><td><div class="TD-content" {[this.divStyle("P90160100")]}></div></td>',
						'<td><div class="TD-title">��������ʱ��1</div></td><td><div class="TD-content" {[this.divStyle("P90160200")]}></div></td>',
						'<td><div class="TD-title">������������1</div></td><td><div class="TD-content" {[this.divStyle("P90160300")]}></div></td>',
						'<td><div class="TD-title">����ּ�1</div></td><td><div class="TD-content" {[this.divStyle("P90160400")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">��������2</div></td><td><div class="TD-content" {[this.divStyle("P90170600")]}></div></td>',
						'<td><div class="TD-title">�������2</div></td><td><div class="TD-content" {[this.divStyle("P90170100")]}></div></td>',
						'<td><div class="TD-title">��������ʱ��2</div></td><td><div class="TD-content" {[this.divStyle("P90170200")]}></div></td>',
						'<td><div class="TD-title">������������2</div></td><td><div class="TD-content" {[this.divStyle("P90170300")]}></div></td>',
						'<td><div class="TD-title">����ּ�2</div></td><td><div class="TD-content" {[this.divStyle("P90170400")]}></div></td>',
					'</tr></table>', 
					 '<table><tr>',
						'<td><div class="TD-title">��������3</div></td><td><div class="TD-content" {[this.divStyle("P90180600")]}></div></td>',
						'<td><div class="TD-title">�������3</div></td><td><div class="TD-content" {[this.divStyle("P90180100")]}></div></td>',
						'<td><div class="TD-title">��������ʱ��3</div></td><td><div class="TD-content" {[this.divStyle("P90180200")]}></div></td>',
						'<td><div class="TD-title">������������3</div></td><td><div class="TD-content" {[this.divStyle("P90180300")]}></div></td>',
						'<td><div class="TD-title">����ּ�3</div></td><td><div class="TD-content" {[this.divStyle("P90180400")]}></div></td>',
					'</tr></table>', 
				'</div></td></tr>',
			'</tbody>',
		'</table>',
		{
			divStyle : function(ItemCode){
				var tabEv = ''
				tabEv += ' id="Cmp_' + 'FPM_Editor_Item' + ItemCode + '"'
				//tabEv += ' style="width:100%;overflow:hidden;"'
				return tabEv;
			}
		}
	);
	
	
	obj.FPM_CreatEditorItems = function(arrItem){
		obj.FPM_Editor.Items.length = 0;
		var cmpName = 'FPM_Editor_Item';
		var itemId = '',itemDesc = '',itemValue = '',itemText = '';
		
		for (var ind = 0; ind < arrItem.length; ind++){
			var objItem = arrItem[ind];
			itemId = cmpName + objItem.ItemCode;
			itemDesc = objItem.ItemDesc;
			
			if (objItem.TypeCode == 'D'){
				var objCmp = FP_ComboDic(itemId,itemDesc,objItem.DicCode);
			} else if (objItem.TypeCode == 'T'){
				var objCmp = FP_TextField(itemId,itemDesc);
			} else if (objItem.TypeCode == 'N'){
				var objCmp = FP_NumberField(itemId,itemDesc);
			} else if (objItem.TypeCode == 'DD'){
				var objCmp = FP_DateField(itemId,itemDesc);
			} else {
				continue;
			}
			obj.FPM_Editor.Items.push(objCmp);
		}
		
		obj.FPM_GetDataFromEpr(obj.FPM_Editor.Items)
	}
	obj.FPM_GetDataFromEpr = function(arrItem){
		var conn = Ext.lib.Ajax.getConnectionObject().conn;
		var url = ExtToolSetting.RunQueryPageURL + '?1=1'
		url += '&ClassName=' + 'DHCWMR.FPService.FrontPageGet'
		url += '&QueryName=' + 'QryFrontPageInfo'
		url += '&Arg1=' + obj.FrontPage.FrontPageID
		url += '&Arg2=' + obj.FrontPage.VolumeID
		url += '&ArgCnt=' + 2
		url += '&2=2'
		conn.open('post',url,false);
		conn.send(null);
		
		if (conn.status != '200') {
			ExtTool.alert('����', '��ѯQuery����3!');
			return false;
		}
		
		var jsonData = new Ext.decode(conn.responseText);
		if (jsonData.total < 1){
			ExtTool.alert('�ٴ�����δͬ��!');
			//return false;
		} else {
			var arryData = new Array();
			var objData = null;
			for (var row = 0; row < jsonData.record.length; row++){
				objData = jsonData.record[row];
				var Datakey = 'FPM_Editor_Item'+objData.DataCode;
				arryData[Datakey] = objData.DataValue;
			}
			
			for (var ind = 0; ind < arrItem.length; ind++){
				var objItem = arrItem[ind];
				var tmpID=objItem.id;
				var tmpValue=arryData[tmpID];
				Common_SetValue(tmpID,tmpValue,tmpValue);
			}
		}
	}
	
	obj.FPM_GetEditData = function(arrItem) {
		var DataStr='EpisodeID' + CHR_2 + VolPaadm;
		for (var ind = 0; ind < arrItem.length; ind++){
			var objItem = arrItem[ind];
			var tmpID=objItem.id;
			var tmpCode=tmpID.split("_Item")[1];
			var tmpvalue=Common_GetText(tmpID);
			DataStr = DataStr + CHR_1 + tmpCode + CHR_2 + tmpvalue;
		}
		return DataStr;
	}
}