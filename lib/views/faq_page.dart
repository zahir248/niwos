import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF004AAD),
        title: Text('FAQ'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: 'Administrator'),
            FAQItem(
              question: 'User Management',
              answer: '''
How do I create a new user account?

To create a new user account, log in to the administrator dashboard and navigate to the "User Management" section. Click on the "Create User" button, fill in the required details such as username, email, and role, and then click "Save" to create the account.

Can I update user account information?

Yes, you can update user account information by selecting the user from the list in the "User Management" section, making the necessary changes, and clicking "Update" to save the modifications.

What steps are involved in deleting a user account?

To delete a user account, go to the "User Management" section, select the user you want to delete, and click on the "Delete" button. Confirm the deletion when prompted.
''',
            ),
            FAQItem(
              question: 'Attendance Monitoring',
              answer: '''
How can I access the attendance report?

To access the attendance report, navigate to the "Attendance Monitoring" section in the administrator dashboard. You can generate and view detailed attendance reports for specific time periods.

What information is included in the attendance report?

The attendance report includes data such as employee names, dates, clock-in/out times, total hours worked, and any deviations from the standard schedule.
''',
            ),
            FAQItem(
              question: 'Access Control Management',
              answer: '''
How do I define access areas?

Access areas can be defined by specifying the locations or zones within the premises and assigning unique identifiers to each area in the system.

Can I assign access permissions to employees?

Yes, you can assign access permissions to employees by selecting their profiles in the system and configuring the areas they are authorized to access.

What is the process for managing access permission requests?

Access permission requests can be managed through the "Access Control Management" section. Administrators can review requests, approve or deny them based on company policies, and update access permissions accordingly.
''',
            ),
            FAQItem(
              question: 'Payment Monitoring',
              answer: '''
Where can I view payment transactions and reports?

Payment transactions and reports can be viewed in the "Payment Monitoring" section of the administrator dashboard. This section provides insights into financial transactions and helps track payment activities.
''',
            ),
            SectionTitle(title: 'Manager'),
            FAQItem(
              question: 'Team Management',
              answer: '''
How do I view the list of team members?

Managers can view the list of team members by accessing the "Team Management" section in their dashboard. This section displays the names and roles of all team members.

Can I make changes to the team member list?

Yes, managers have the authority to make changes to the team member list. They can add new members, update existing profiles, or remove team members as needed.
''',
            ),
            FAQItem(
              question: 'Attendance Management',
              answer: '''
How do I access attendance reports for my team?

Managers can access attendance reports for their team by navigating to the "Attendance Management" section. They can generate customized reports and analyze attendance data for individual team members or the entire team.

What options do I have to address attendance-related issues?

Managers can address attendance-related issues by reviewing attendance records, identifying patterns or discrepancies, and taking appropriate actions such as counseling employees or implementing corrective measures.

How can I manage leave requests for my team members?

Leave requests can be managed through the "Attendance Management" section. Managers can review leave requests, approve or deny them based on staffing needs, and update leave balances accordingly.
''',
            ),
            SectionTitle(title: 'Employee'),
            FAQItem(
              question: 'Attendance Tracking',
              answer: '''
How do I punch in and out?

Employees can punch in and out by using designated timekeeping devices or logging into the system and selecting the "Clock In" or "Clock Out" option.

Where can I view my attendance records?

Employees can view their attendance records in the "Attendance Tracking" section of their dashboard. This section displays their clock-in/out times, total hours worked, and any attendance-related information.

What is the process for submitting leave requests?

Leave requests can be submitted through the "Attendance Tracking" section. Employees can select the type of leave, specify the dates, and provide any necessary details before submitting the request for approval.
''',
            ),
            FAQItem(
              question: 'Access Control',
              answer: '''
How can I request access to specific areas?

Employees can request access to specific areas by filling out the access request form available in the "Access Control" section. They need to provide relevant information such as the reason for access and the desired duration.

Where can I view my access permissions?

Access permissions can be viewed in the "Access Control" section of the employee dashboard. This section displays the areas to which the employee has access and any associated restrictions.
''',
            ),
            FAQItem(
              question: 'Payment',
              answer: '''
How can I make cashless payments using digital ID cards?

Employees can make cashless payments using their digital ID cards at designated points of sale, such as cafeterias or vending machines, by tapping or scanning their cards at the payment terminals.

Where are the designated points of sale for making payments?

The designated points of sale for making payments are typically located in common areas within the premises, such as cafeterias, retail stores, or service counters.
''',
            ),
            FAQItem(
              question: 'Self-Service',
              answer: '''
How can I update my personal information?

Employees can update their personal information by accessing the "Self-Service" section of their dashboard and selecting the option to edit their profile. They can then make changes to their contact details, emergency contacts, or other relevant information.
''',
            ),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Q: $question',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.0),
        Text('A: $answer'),
        Divider(),
      ],
    );
  }
}