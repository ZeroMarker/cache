Class User.DHCEQImportData Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = ET_RowID, SqlTableName = DHC_EQImportData, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Property EquipType As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = EquipType ];

Property StatCat As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = StatCat ];

Property EquipCat As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = EquipCat ];

Property EquipNo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = EquipNo ];

Property EquipName As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = EquipName ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = Code ];

Property Model As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = Model ];

Property Quantity As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = Quantity ];

Property Unit As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = Unit ];

Property OriginalFee As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = OriginalFee ];

Property UseLoc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = UseLoc ];

Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = Status ];

Property InStockDate As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = InStockDate ];

Property TransAssetDate As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = TransAssetDate ];

Property DepreMethod As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = DepreMethod ];

Property LimitYears As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = LimitYears ];

Property DepreTotalFee As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = DepreTotalFee ];

Property RemainRate As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = RemainRate ];

Property Provider As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = Provider ];

Property ManuFacturer As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = ManuFacturer ];

Property LeaveFactoryNo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = LeaveFactoryNo ];

Property LeaveFactoryDate As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = LeaveFactoryDate ];

Property Country As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = Country ];

Property PurposeType As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = PurposeType ];

Property Origin As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = Origin ];

Property Manager As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = Manager ];

Property Keeper As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = Keeper ];

Property FormToDept As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 29, SqlFieldName = FormToDept ];

Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 30, SqlFieldName = Remark ];

Property OldLoc As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 31, SqlFieldName = OldLoc ];

Property DisusedDate As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 32, SqlFieldName = DisusedDate ];

Property MemoryCode As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 33, SqlFieldName = MemoryCode ];

Property ServiceHandler As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 34, SqlFieldName = ServiceHandler ];

Property AccountNo As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 35, SqlFieldName = AccountNo ];

Property OldID As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 36, SqlFieldName = OldID ];

Property FundsStr As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 37, SqlFieldName = FundsStr ];

Property BuildingArea As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 38, SqlFieldName = BuildingArea ];

Property Brand As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 39, SqlFieldName = Brand ];

Property FundsOrigin As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 40, SqlFieldName = FundsOrigin ];

Property PeriodNum As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 41, SqlFieldName = PeriodNum ];

Property Hold2 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 42, SqlFieldName = Hold2 ];

Property Hold3 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 43, SqlFieldName = Hold3 ];

Property Hold4 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 44, SqlFieldName = Hold4 ];

Property Hold5 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 45, SqlFieldName = Hold5 ];

Property Hold6 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 46, SqlFieldName = Hold6 ];

Property Hold7 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 47, SqlFieldName = Hold7 ];

Property Hold8 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 48, SqlFieldName = Hold8 ];

Property Hold9 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 49, SqlFieldName = Hold9 ];

Property Hold10 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 50, SqlFieldName = Hold10 ];

Property Hold11 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 51, SqlFieldName = Hold11 ];

Property Hold12 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 52, SqlFieldName = Hold12 ];

Property Hold13 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 53, SqlFieldName = Hold13 ];

Property Hold14 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 54, SqlFieldName = Hold14 ];

Property Hold15 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 55, SqlFieldName = Hold15 ];

Property Hold16 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 56, SqlFieldName = Hold16 ];

Property Hold17 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 57, SqlFieldName = Hold17 ];

Property Hold18 As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 58, SqlFieldName = Hold18 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQImportData(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AccountNo">
<Delimiter>"^"</Delimiter>
<Piece>34</Piece>
</Data>
<Data name="Brand">
<Delimiter>"^"</Delimiter>
<Piece>38</Piece>
</Data>
<Data name="BuildingArea">
<Delimiter>"^"</Delimiter>
<Piece>37</Piece>
</Data>
<Data name="Code">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="Country">
<Delimiter>"^"</Delimiter>
<Piece>23</Piece>
</Data>
<Data name="DepreMethod">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="DepreTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>17</Piece>
</Data>
<Data name="DisusedDate">
<Delimiter>"^"</Delimiter>
<Piece>31</Piece>
</Data>
<Data name="EquipCat">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EquipName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EquipNo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EquipType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="FormToDept">
<Delimiter>"^"</Delimiter>
<Piece>28</Piece>
</Data>
<Data name="FundsOrigin">
<Delimiter>"^"</Delimiter>
<Piece>39</Piece>
</Data>
<Data name="FundsStr">
<Delimiter>"^"</Delimiter>
<Piece>36</Piece>
</Data>
<Data name="Hold10">
<Delimiter>"^"</Delimiter>
<Piece>49</Piece>
</Data>
<Data name="Hold11">
<Delimiter>"^"</Delimiter>
<Piece>50</Piece>
</Data>
<Data name="Hold12">
<Delimiter>"^"</Delimiter>
<Piece>51</Piece>
</Data>
<Data name="Hold13">
<Delimiter>"^"</Delimiter>
<Piece>52</Piece>
</Data>
<Data name="Hold14">
<Delimiter>"^"</Delimiter>
<Piece>53</Piece>
</Data>
<Data name="Hold15">
<Delimiter>"^"</Delimiter>
<Piece>54</Piece>
</Data>
<Data name="Hold16">
<Delimiter>"^"</Delimiter>
<Piece>55</Piece>
</Data>
<Data name="Hold17">
<Delimiter>"^"</Delimiter>
<Piece>56</Piece>
</Data>
<Data name="Hold18">
<Delimiter>"^"</Delimiter>
<Piece>57</Piece>
</Data>
<Data name="Hold2">
<Delimiter>"^"</Delimiter>
<Piece>41</Piece>
</Data>
<Data name="Hold3">
<Delimiter>"^"</Delimiter>
<Piece>42</Piece>
</Data>
<Data name="Hold4">
<Delimiter>"^"</Delimiter>
<Piece>43</Piece>
</Data>
<Data name="Hold5">
<Delimiter>"^"</Delimiter>
<Piece>44</Piece>
</Data>
<Data name="Hold6">
<Delimiter>"^"</Delimiter>
<Piece>45</Piece>
</Data>
<Data name="Hold7">
<Delimiter>"^"</Delimiter>
<Piece>46</Piece>
</Data>
<Data name="Hold8">
<Delimiter>"^"</Delimiter>
<Piece>47</Piece>
</Data>
<Data name="Hold9">
<Delimiter>"^"</Delimiter>
<Piece>48</Piece>
</Data>
<Data name="InStockDate">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="Keeper">
<Delimiter>"^"</Delimiter>
<Piece>27</Piece>
</Data>
<Data name="LeaveFactoryDate">
<Delimiter>"^"</Delimiter>
<Piece>22</Piece>
</Data>
<Data name="LeaveFactoryNo">
<Delimiter>"^"</Delimiter>
<Piece>21</Piece>
</Data>
<Data name="LimitYears">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="Manager">
<Delimiter>"^"</Delimiter>
<Piece>26</Piece>
</Data>
<Data name="ManuFacturer">
<Delimiter>"^"</Delimiter>
<Piece>20</Piece>
</Data>
<Data name="MemoryCode">
<Delimiter>"^"</Delimiter>
<Piece>32</Piece>
</Data>
<Data name="Model">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="OldID">
<Delimiter>"^"</Delimiter>
<Piece>35</Piece>
</Data>
<Data name="OldLoc">
<Delimiter>"^"</Delimiter>
<Piece>30</Piece>
</Data>
<Data name="Origin">
<Delimiter>"^"</Delimiter>
<Piece>25</Piece>
</Data>
<Data name="OriginalFee">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PeriodNum">
<Delimiter>"^"</Delimiter>
<Piece>40</Piece>
</Data>
<Data name="Provider">
<Delimiter>"^"</Delimiter>
<Piece>19</Piece>
</Data>
<Data name="PurposeType">
<Delimiter>"^"</Delimiter>
<Piece>24</Piece>
</Data>
<Data name="Quantity">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RemainRate">
<Delimiter>"^"</Delimiter>
<Piece>18</Piece>
</Data>
<Data name="Remark">
<Delimiter>"^"</Delimiter>
<Piece>29</Piece>
</Data>
<Data name="ServiceHandler">
<Delimiter>"^"</Delimiter>
<Piece>33</Piece>
</Data>
<Data name="StatCat">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Status">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="TransAssetDate">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="Unit">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="UseLoc">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCEQImportData</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ET_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{ET_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQImportDataS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
