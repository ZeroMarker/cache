/**!
* date:2019-04-02
* desc��DLL/ocx����ӿڵ��÷�װjs��ģ��,�ο���
* �ӿڳ��ң�
* creator��������
*/

//ҵ����津�����¼��ӿڵ��ú��������磺������ҩ�ġ�ҩ����ʾ��
function templateBtn_Click(){
	XXX_Interface.Funcs.QueryFunc();
}

//��ҵ�������ã����ýӿں���A
function template_InterfaceA(){
	XXX_Interface.Funcs.HanderFunA();
}

//��ҵ�������ã����ýӿں���B
function template_InterfaceB(){
	XXX_Interface.Funcs.HanderFunB()
}


//�ӿں�����װ
var XXX_Interface={
	Funcs:{
		QueryFunc:function () {
			var Data=this.getData();
			var Data=this.FormatData(Data);
		    ///todo ���ο���API�ӿں�������
		    ///...
		    return Data;
		},
		///�ӿں���A
		HanderFunA:function () {
		    var myrtn="";
		    ///todo ���ο���API�ӿں�������
		    ///...
		    return myrtn;
		},
		///�ӿں���B
		HanderFunB:function (){
			var myrtn="";
		    ///todo ���ο���API�ӿں�������
		    ///...
		    return myrtn;
		},
		//ͨ��ǰ�˻�ȡ���ݺ�����ʾ�⡿
		getData:function () {
		    var jsonRtn={};
		    ///todo ������Ҫ��ȡҳ�����ݴ���
		    ///...
			
		   return jsonRtn;
		},
		//����������ʾ�⡿
		FormatData:function (Data) {
		    ///todo ������Ҫ��ʽ������
		    ///...
		    
		    return Data;
		   
		}
	}
}




