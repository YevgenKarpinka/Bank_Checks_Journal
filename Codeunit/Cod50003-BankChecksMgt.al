codeunit 50003 "Bank Checks Mgt."
{
    trigger OnRun()
    begin

    end;

    procedure SetBankCheckStatus(_BankCheck: Record "Bank Check Journal Line"; _newStatus: Integer)
    begin
        with _BankCheck do begin
            if FindSet(true, false) then
                repeat
                    Status := _newStatus;
                    Modify();
                    if Status = Status::Confirmed then begin
                        // Create Payment Journal Line
                        // to do
                    end;
                until Next() = 0;
        end;
    end;

    local procedure GetGLSetup()
    begin
        GLSetup.Get();
    end;

    procedure CreatePaymentFromBankCheck(_BankCheck: Record "Bank Check Journal Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        LastGenJnlLine: Record "Gen. Journal Line";
        LineNo: Integer;
    begin
        GetGLSetup();
        GLSetup.TESTFIELD("Journal Template Name");
        GLSetup.TESTFIELD("Journal Batch Name");
        GenJnlLine.SetCurrentKey("Journal Template Name", "Journal Template Name", "External Document No.", "Document Date");
        GenJnlLine.SETRANGE("Journal Template Name", GLSetup."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", GLSetup."Journal Batch Name");
        GenJnlLine.SETRANGE("External Document No.", _BankCheck."Bank Check No.");
        GenJnlLine.SETRANGE("Document Date", _BankCheck."Bank Check Date");
        IF NOT GenJnlLine.ISEMPTY THEN
            EXIT; // instead; go to the document

        if PostedBankCheckExist(_BankCheck."Bank Check No.") then exit;

        GenJnlLine.SETRANGE("External Document No.");
        GenJnlLine.SETRANGE("Document Date");
        IF GenJnlLine.FINDLAST THEN;
        LastGenJnlLine := GenJnlLine;
        LineNo := GenJnlLine."Line No." + 10000;

        GenJnlLine.INIT;
        GenJnlLine."Journal Template Name" := GLSetup."Journal Template Name";
        GenJnlLine."Journal Batch Name" := GLSetup."Journal Batch Name";
        GenJnlLine."Line No." := LineNo;
        GenJnlLine.SetUpNewLine(LastGenJnlLine, 0, TRUE);
        GenJnlLine.Validate("External Document No.", _BankCheck."Bank Check No.");
        GenJnlLine.Validate("Document Date", _BankCheck."Bank Check Date");
        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
        GenJnlLine.Validate("Account No.", _BankCheck."Customer No.");
        GenJnlLine.Validate(Description, COPYSTR(_BankCheck.Description, 1, MAXSTRLEN(GenJnlLine.Description)));
        GenJnlLine.Validate(Amount, _BankCheck.Amount);

        IF GenJnlLine.INSERT(TRUE) THEN;
    end;


    local procedure PostedBankCheckExist(BankCheckNo: Code[35]): Boolean
    var
        GLEntry: Record "G/L Entry";
    begin
        with GLEntry do begin
            SetCurrentKey("External Document No.");
            SetRange("External Document No.", BankCheckNo);
            exit(not IsEmpty);
        end;
    end;

    var
        GLSetup: Record "General Ledger Setup";
}