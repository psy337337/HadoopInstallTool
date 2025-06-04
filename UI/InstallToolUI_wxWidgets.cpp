#include <vector>
#include <string>
#include <memory>
#include <wx/wx.h>
#include <wx/listctrl.h>

// 우분투 내에서 빌드할 때 사용한 명령어
// g++ -std=c++20 -o listview_editor listview_editor.cpp `wx-config --cxxflags --libs`

// 우분투 내의 설치 패키지
// sudo apt update
// sudo apt upgrade
// sudo apt install libwxgtk3.2-dev
// sudo apt install build-essential
// sudo apt install cmake
// sudo apt install ninja-build
// sudo apt install libopencv-
// sudo apt install clang-format

enum class FormMode
{
    Edit,
    Add
};

// 편집 팝업 창
class EditDialog : public wxDialog
{
public:
    EditDialog(wxWindow *parent, const wxString &addressValue, const wxString &passwordValue, FormMode mode)
        : wxDialog(parent, wxID_ANY, "Dialog Title", wxDefaultPosition, wxSize(300, 150))
    {
        InitializeUI(addressValue, passwordValue, mode, true);
    }

    EditDialog(wxWindow *parent, const wxString &addressValue, FormMode mode)
        : wxDialog(parent, wxID_ANY, "Dialog Title", wxDefaultPosition, wxSize(300, 150))
    {
        InitializeUI(addressValue, "", mode, false);
    }

    wxString GetAddress() const
    {
        return textAddress->GetValue();
    }

    wxString GetPassword() const
    {
        return textPassword->GetValue();
    }

private:
    wxTextCtrl *textAddress;
    wxTextCtrl *textPassword = nullptr; // Optional

    void InitializeUI(const wxString &addressValue, const wxString &passwordValue, FormMode mode, bool includePassword)
    {
        SetTitle(mode == FormMode::Edit ? "Edit Item" : mode == FormMode::Add ? "Add Item"
                                                                              : "Error");

        wxBoxSizer *sizer = new wxBoxSizer(wxVERTICAL);

        // 주소 필드
        wxBoxSizer *addressSizer = new wxBoxSizer(wxHORIZONTAL);
        addressSizer->Add(new wxStaticText(this, wxID_ANY, "IP Address:"), 0, wxALL, 10);
        textAddress = new wxTextCtrl(this, wxID_ANY, addressValue);
        addressSizer->Add(textAddress, 0, wxALL, 10);
        sizer->Add(addressSizer, 1, wxALIGN_LEFT);

        // 비밀번호 필드 (선택적)
        if (includePassword)
        {
            wxBoxSizer *passwordSizer = new wxBoxSizer(wxHORIZONTAL);
            passwordSizer->Add(new wxStaticText(this, wxID_ANY, "Password:"), 0, wxALL, 10);
            textPassword = new wxTextCtrl(this, wxID_ANY, passwordValue);
            passwordSizer->Add(textPassword, 0, wxALL, 10);
            sizer->Add(passwordSizer, 1, wxALIGN_LEFT);
        }

        // 버튼
        wxBoxSizer *btnSizer = new wxBoxSizer(wxHORIZONTAL);
        btnSizer->Add(new wxButton(this, wxID_OK, "Apply"), 0, wxALL, 5);
        btnSizer->Add(new wxButton(this, wxID_CANCEL, "Cancel"), 0, wxALL, 5);
        sizer->Add(btnSizer, 1, wxALIGN_RIGHT);

        SetSizerAndFit(sizer);
    }
};

// 메인 프레임
class NameNodeFrame : public wxFrame
{
public:
    NameNodeFrame()
        : wxFrame(nullptr, wxID_ANY, "Hadoop install program", wxDefaultPosition, wxSize(500, 1000))
    {

        wxBoxSizer *mainSizer = new wxBoxSizer(wxVERTICAL);

        // ======================== 첫 번째 리스트뷰 ========================
        wxStaticBoxSizer *listSizer1 = new wxStaticBoxSizer(wxVERTICAL, this, "Name Node Setting");

        // 리스트 셋팅
        listView1 = new wxListView(this, wxID_ANY, wxDefaultPosition, wxDefaultSize, wxLC_REPORT);
        listView1->InsertColumn(0, "Address");

        // 초기값 삽입
        long itemIndex = listView1->InsertItem(0, "127.0.0.1");

        // 편집 버튼
        wxButton *editButton1 = new wxButton(this, wxID_ANY, "Edit");
        editButton1->Bind(wxEVT_BUTTON, &NameNodeFrame::OnEditList1, this);

        // 리스트 뷰 sizer 저장
        listSizer1->Add(listView1, 0, wxEXPAND | wxALL, 5);
        listSizer1->Add(editButton1, 0, wxALIGN_RIGHT | wxALL, 5);

        // ======================== 두 번째 리스트뷰 ========================
        wxStaticBoxSizer *listSizer2 = new wxStaticBoxSizer(wxVERTICAL, this, "Data Node Setting");

        // 리스트 셋팅
        listView2 = new wxListView(this, wxID_ANY, wxDefaultPosition, wxDefaultSize, wxLC_REPORT);
        listView2->InsertColumn(0, "Address");
        listView2->InsertColumn(1, "Password");

        // 초기값 삽입
        long itemIndex2 = listView2->InsertItem(0, "127.0.0.1");
        listView2->SetItem(itemIndex2, 1, "12345678");

        // mainSizer->Add(sizer2, 1, wxEXPAND | wxALL, 10);

        //////////////////////
        // 버튼들 추가 - 두번째 리스트뷰에 (DataNode)
        //////////////////////
        wxBoxSizer *buttonRow = new wxBoxSizer(wxHORIZONTAL);

        wxButton *addButton2 = new wxButton(this, wxID_ANY, "Add");
        wxButton *editButton2 = new wxButton(this, wxID_ANY, "Edit");
        wxButton *deleteButton2 = new wxButton(this, wxID_ANY, "Delete");

        // 버튼 함수 연결
        addButton2->Bind(wxEVT_BUTTON, &NameNodeFrame::AddList, this);
        editButton2->Bind(wxEVT_BUTTON, &NameNodeFrame::OnEditList2, this);
        deleteButton2->Bind(wxEVT_BUTTON, &NameNodeFrame::DeleteList, this);

        // 버튼 추가
        buttonRow->Add(addButton2, 0, wxALL, 5);
        buttonRow->Add(editButton2, 0, wxALL, 5);
        buttonRow->Add(deleteButton2, 0, wxALL, 5);

        // 리스트뷰 sizer 저장
        listSizer2->Add(listView2, 0, wxEXPAND | wxALL, 5);
        listSizer2->Add(buttonRow, 0, wxALIGN_RIGHT | wxBOTTOM, 5);
        // mainSizer->Add(buttonRow, 0, wxALIGN_CENTER_HORIZONTAL | wxBOTTOM, 10);

        // ======================== 최종 버튼 ========================
        wxBoxSizer *mainButtonSizer = new wxBoxSizer(wxHORIZONTAL);

        wxButton *startButton = new wxButton(this, wxID_ANY, "Start");
        wxButton *cancelButton = new wxButton(this, wxID_ANY, "Cancel");

        // 버튼 함수 연결
        startButton->Bind(wxEVT_BUTTON, &NameNodeFrame::Start, this);
        cancelButton->Bind(wxEVT_BUTTON, &NameNodeFrame::OnExit, this);

        // 버튼 추가
        mainButtonSizer->Add(startButton, 0, wxALL, 5);
        mainButtonSizer->Add(cancelButton, 0, wxALL, 5);

        // =========================================================
        // 메인 sizer에 NameNode, DataNode 세팅 추가
        mainSizer->Add(listSizer1, 0, wxEXPAND | wxALL, 10);
        mainSizer->Add(listSizer2, 0, wxEXPAND | wxALL, 10);
        mainSizer->Add(mainButtonSizer, 0, wxALIGN_RIGHT | wxBOTTOM, 10);

        // 프레임에 메인 사이저 적용
        SetSizer(mainSizer);
    }

private:
    wxListView *listView1;
    wxListView *listView2;

    void Start(wxCommandEvent &)
    {
        std::string value = "sh hello.sh " + ListViewToString();
        int result = system(value.c_str()); // 또는 "bash my_script.sh"
        if (result == 0)
        {
            // listView는 wxListView* 객체라고 가정

            std::cout << "실행 완료\n";
            // 성공적으로 실행됨
        }
        else
        {
            std::cout << "실행 실패\n";
            // 오류 처리
        }
    }
    void OnExit(wxCommandEvent &)
    {
        Close(true);
    }

    void OnEditList1(wxCommandEvent &)
    {
        EditListItem(listView1, false);
    }

    void OnEditList2(wxCommandEvent &)
    {
        EditListItem(listView2, true);
    }

    void EditListItem(wxListView *listView, bool hasPassword)
    {
        if (!listView)
        {
            wxLogError("ListView 포인터가 null입니다!");
            return;
        }

        long selected = listView->GetFirstSelected();
        if (selected == -1)
            return;

        wxString addressValue = listView->GetItemText(selected, 0);
        wxString passwordValue;

        if (hasPassword)
            passwordValue = listView->GetItemText(selected, 1);

        // 다이얼로그 생성 및 표시
        std::unique_ptr<EditDialog> dlg;
        if (hasPassword)
            dlg = std::make_unique<EditDialog>(this, addressValue, passwordValue, FormMode::Edit);
        else
            dlg = std::make_unique<EditDialog>(this, addressValue, FormMode::Edit);

        if (dlg->ShowModal() == wxID_OK)
        {
            listView->SetItem(selected, 0, dlg->GetAddress());
            if (hasPassword)
                listView->SetItem(selected, 1, dlg->GetPassword());
        }
    }

    void AddList(wxCommandEvent &)
    {
        EditDialog dlg(this, "", "", FormMode::Add);

        if (dlg.ShowModal() == wxID_OK)
        {
            long itemIndex = listView2->InsertItem(0, dlg.GetAddress());
            listView2->SetItem(itemIndex, 1, dlg.GetPassword());
        }
    }

    void DeleteList(wxCommandEvent &)
    {
        long selected = listView2->GetFirstSelected();
        if (selected == -1)
        {
            wxMessageBox("Please select an item to edit.", "No Selection", wxICON_WARNING);
            return;
        }
        listView2->DeleteItem(selected);
    }

    std::string ListViewToString()
    {
        std::vector<std::string> stringArray;
        GetListViewItems(listView1, {0}, stringArray);    // listView1: 1열만 추출
        GetListViewItems(listView2, {0, 1}, stringArray); // listView2: 0열, 1열 추출

        std::string listViewToString = "";
        for (const std::string &str : stringArray)
        { // 각 문자를 ch로 순회
            listViewToString += str + " ";
        }
        return listViewToString;
    }

    void GetListViewItems(wxListView *listView, const std::vector<int> &columns, std::vector<std::string> &stringArray)
    {
        int rowCount = listView->GetItemCount();

        for (int row = 0; row < rowCount; ++row)
        {
            for (int col : columns)
            {
                wxListItem item;
                item.SetId(row);
                item.SetColumn(col);

                if (listView->GetItem(item))
                {
                    stringArray.push_back(std::string(item.GetText().mb_str()));
                }
            }
        }
    }
};

// 애플리케이션 클래스
class MyApp : public wxApp
{
public:
    virtual bool OnInit() override
    {
        NameNodeFrame *frame = new NameNodeFrame();
        frame->Show(true);
        return true;
    }
};

wxIMPLEMENT_APP(MyApp);
