$(function(){ 
	
	initButton();			//��ʼ����ť

})
function initButton()
{
	$("#find").bind("click",TakCheck);			// ����
}
function TakCheck()
{
	
		/**  
	     * ��ʼ������PDSS���� 
	 */  
	 var pdss = new PDSS({});  
		/*var PdssObj = {  
	     "Action":"",   //  Ӧ�ó�����CheckRule����ҩ���,EduRule ��ҩָ��,Cdss:cdssӦ�ã�
	     "MsgID":"",          //  �����־id����д�����ã�
	     "PatName":"����",        //  ����  
	     "SexProp":"��",          // �Ա�  
	     "AgeProp":"1993-02-10", // ��������  
	     "Height":"170",         // ���(����ֵ)  
	     "Weight":"51",          // ����(kg)   
	     "BillType":"ҽ��",      // �ѱ� (ҽ��,�Է�)  
	     "BloodPress":"",        // Ѫѹ  
	     "SpecGrps":["�����ܲ�ȫ","�и�"],  //������Ⱥ  
	     "ProfessProp":"�˶�Ա",    // ְҵ  
	     "PatType":"����",          // �������(����,סԺ,����)  
	     "PatLoc":"�����ڿ�",       // �������  
	     "MainDoc":"ʯ�Ƿ�",        // ����ҽ��  
	     "EpisodeID":"001",        // ����ID  
	     "ItemAyg":[               // ������¼  
        {  
	            "id":"itemAyg",   // ��ʶ  
	            "item":"��ù��"    // ������Ŀ  
	       }  
	    ],  
	    "ItemDis":[               // ����  
	        {  
	            "id":"itemDis",   // ��ʶ  
	            "item":"����"      // ����  
	        },  
	        {  
	            "id":"itemDis",  
	            "item":"�ж���"  
	        }  
	    ],  
	    "ItemLab":[        // ����  
	        {  
	            "id":"itemLab",   // ��ʶ  
	            "item":"��ϸ��"   // ������Ŀ  
	        }  
	    ],  
	    "ItemLabDetail":[        // ������Ŀ��ϸ 
	        {  
	            "Val":"10",       // ������ֵ  
	            "Unit":"mg",      // ������ֵ��λ  
	            "id":"labDetail",   // ��ʶ  
            "item":"��ϸ��"   // ������Ŀ  
	        }  
	    ],
	    "ItemOper":[        // ����  
	        {     
	            "id":"itemOper",    // ��ʶ  
	            "item":"­���к���"  // ��������  
	        }  
	    ],  
	    "ItemOrder":[         // ҩƷ  
	        {  
	            "SeqNo":"1",                // ҽ�����  
	            "PhDesc":"��˾ƥ�ֳ���Ƭ",   // ҩƷ����  
	            "FormProp":"Ƭ��",          // ����  
	            "OnceDose":"200",           // ���μ���  
	            "Unit":"mg",                // ���μ�����λ  
	            "DrugPreMet":"�ڷ�",         // �÷�  
	            "DrugFreq":"tid",           // Ƶ��  
	            "Treatment":"1��",          // �Ƴ�  
	            "id":"itemOrder",           // ��ʶ  
	            "LinkSeqNo":"1",            // �������(1, 1.1, 1.2)  
	            "OrdDate":"2020-03-06",     // ҽ������  
	            "IsFirstUseProp":"�״�",    // �Ƿ��״�(�״�/���״�)  
	            "DurgSpeedProp":"" ,         // ��ҩ�ٶ� 
	            "DrugSpeedPropUnit":""		// ��ҩ�ٶȵ�λ
	              
	        },  
	        {  
	            "SeqNo":"2",                  // ҽ�����  
	            "PhDesc":"��������������Һ",  // ҩƷ����  
	            "FormProp":"���ۼ�",           // ����  
             "OnceDose":"2",               // ���μ���  
	            "Unit":"��",                  // ���μ�����λ  
	            "DrugPreMet":"����",          // �÷�  
	            "DrugFreq":"ÿ��4��",        // Ƶ��  
	            "Treatment":"2��",           // �Ƴ�  
	            "LinkSeqNo":"2.2",           // �������(1, 1.1, 1.2)  
	            "id":"itemOrder",            // ��ʶ  
	            "OrdDate":"2020-03-06",      // ҽ������  
	            "IsFirstUseProp":"�״�",      // �Ƿ��״�(�״�/���״�)  
	            "DurgSpeedProp":"1" ,           // ��ҩ�ٶ�  
	 			        "DrugSpeedPropUnit":"��/��"		// ��ҩ�ٶȵ�λ
	        }     
	    ]  
		}  */
		/**  
	     * �������ӿ� 
	     * ����˵���� 
	     * ��һ����������˶��� 
	     * �ڶ����������ص��������ص�����δ��ʱ����null���� 
	     * ��������������鷽ʽ��1 - ��鲻ͨ��ʱ�����������DIV��2 - ������ 
 */ 
 	
 	var PdssObj =
 	{
					"Action": "CheckRule",
					"MsgID": "",
					"PatName": "סԺ2",
					"SexProp": "��",
					"AgeProp": "1996-01-01",
					"Height": "",
					"Weight": " ",
					"BillType": "ȫ�Է�",
					"BloodPress": "120\\90",
					"SpecGrps": ["17", "26"],
					"ProfessProp": "",
					"PatType": "סԺ",
					"PatLoc": "�ڷ��ڿ�",
					"MainDoc": "ҽ��01",
					"EpisodeID": "108",
					"ItemAyg": [],
					"ItemDis": [{
							 "id": "itemDis  ",
								"item": "����"
					}, {
								"id": "itemDis",
								"item": "������ɳ�ž�����"
					}],
					"ItemLab": [],
					"ItemLabDetail": [],
					"ItemOper": [],
					"ItemOrder": [{
								"SeqNo": "1",
								"PhDesc": "0.9%�Ȼ���ע��Һ[500ml]",
								"FormProp": "����Һ",
								"OnceDose": "500",
								"Unit": "ml",
								"DrugPreMet": "������ע",
								"DrugFreq": "St",
								"Treatment": "1��",
								"id": "itemOrder",
								"LinkSeqNo": "",
								"OrdDate": "2020-09-09",
								"IsFirstUseProp": "���״�",
								"DurgSpeedProp": "",
								"DrugSpeedPropUnit": ""
					}],
					"ClientIP": "113.140.81.66"
				}
 	pdss.refresh(PdssObj, null, 1);  /// �������ӿ�
 	/** 
	     * pdss.passFlag  �����ͨ��״̬��0 - ��ͨ����1 - ͨ��:  
	     * pdss.manLevel  ��˽����ʾ�������������ѡ���ʾ����ֹ 
	 */  
	 if(pdss.passFlag == 0) {  
	         
	        /// do something  ��鲻ͨ��ʱ��ִ�д���
	        return;  
	   }  



}