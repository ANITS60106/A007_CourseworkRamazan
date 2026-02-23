Week_002
A client-based project has been selected, thanks to the coursework supervisor.
A project for the coursework has been requested this week due to the Olympiad.
The coursework topic and details will be provided by the supervisor shortly, and it requires waiting. The lead supervisor has priority.
Link to chat with supervisor: https://drive.google.com/file/d/1_ONQI1hsWcM1KQTlGy4SeSbDY1Mam2R5/view?usp=sharing



Week_003
Project description:

My final idea is not just a loan aggregator like Banki.ru or Nova Bank, but a personal financial navigator that helps people not only choose a product, but also understand what is realistically available to them and what financial path is safe.
ClearLoan is a fintech application designed as a financial navigator for Kyrgyzstan, created to help people find loan options that are not only available, but also realistically achievable for their personal situation. Unlike traditional loan marketplaces that simply display interest rates and product catalogs, ClearLoan focuses on guiding users toward the safest and most accessible financial decisions.
I chose to develop ClearLoan because financial accessibility remains a significant issue in Kyrgyzstan, especially outside major cities. Today, in order to obtain a loan, individuals often need to visit multiple banks, submit repeated documents, and wait several days just to understand whether approval is possible. This process leads to wasted time, frustration, and a high number of rejections, particularly for young people, rural residents, and those without a strong credit history.
The main purpose of ClearLoan is to shift the logic from “Where is the cheapest loan?” to “What financial product can I realistically receive right now, and why?” The platform connects banks and microfinance institutions, but works not as a simple showcase, but as an intelligent filter. After completing a short application, the user receives a personalized overview of offers: which loans are likely to be approved, where rejection is possible, and what steps can improve approval chances in the future.
If a loan is not currently accessible, ClearLoan proposes alternative solutions such as smaller amounts, installment plans, microfinance options, or a preparation roadmap. This transforms rejection into a clear next step rather than a dead end, helping users make more responsible financial decisions.
A key advantage of this concept is reducing unnecessary applications and lowering refusal rates. Financial institutions benefit by receiving more qualified and prepared clients, which decreases the workload on branch offices and call centers while improving conversion efficiency. Users benefit by saving time and gaining transparent understanding of their real financial opportunities.
ClearLoan is especially valuable for Kyrgyzstan because it considers local conditions, including weak internet connectivity in many regions. The platform can provide basic offline access through SMS or USSD to check application status and receive offers. Additionally, presenting information in a simple and understandable way, including support for the Kyrgyz language, increases trust and improves financial literacy among users with limited financial background.
Overall, I selected this project because ClearLoan addresses multiple important goals: improving financial inclusion, reducing ineffective loan applications, supporting safer borrowing decisions, and creating a scalable fintech infrastructure that can strengthen the financial ecosystem of Kyrgyzstan.

Competitors:

Several similar platforms already exist internationally, showing that the idea of digital loan marketplaces is востребована, but ClearLoan introduces important improvements adapted specifically for Kyrgyzstan.
One example is LendingTree (USA), one of the largest online loan comparison platforms. It allows users to compare offers from banks and lenders, but it mainly focuses on interest rates rather than approval probability or financial guidance.
Another well-known product is NerdWallet (USA), which provides comparisons of financial products such as loans, credit cards, and insurance. However, it works mostly as an informational catalog and does not offer personalized approval forecasting.
In Europe, Revolut has expanded beyond digital banking into personal finance services, offering loans and credit products directly through the app. Still, it operates mainly within highly developed financial systems and does not target regions with limited banking access.
A similar Russian example is Sravni.ru, which functions as a marketplace for loans, insurance, and banking services. Like Banki.ru, it helps users compare products but does not strongly focus on reducing rejection rates through pre-scoring.
Another relevant case is Credit Karma (USA/UK), which provides users with credit score monitoring and personalized financial recommendations. While it includes some approval-oriented suggestions, it depends heavily on established credit bureau systems that are not fully developed in Kyrgyzstan.
These examples demonstrate that financial marketplaces are common globally, but ClearLoan differentiates itself by combining loan aggregation with approval probability assessment, alternative pathways for users, and offline accessibility features tailored to the specific conditions of Kyrgyzstan.
<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/041fb972-d057-4f20-b670-683614f2b38e" />


What's been accomplished in the third week:
- The app framework was created
- Prospects were discussed with the Elkart MPC
- The app widgets are working properly
- A developer account was purchased

Week_004

Benefits of my app:

The ClearLoan app is a socially significant fintech solution because it helps make banking services more accessible and understandable for a wide range of people in Kyrgyzstan. Today, many people face difficulties obtaining a loan: they must personally visit various banks, fill out numerous documents, wait several days for a decision, and often end up being rejected without explanation. This is especially true for residents of rural areas, young people, the self-employed, and people without a credit history.

ClearLoan solves this problem by serving not just as a loan directory, but as a financial navigator. It helps people understand in advance which offers are actually available to them, where the likelihood of approval is higher, and what steps they need to take to improve their chances. This reduces the number of unfounded applications and rejections, and the process of obtaining financial services becomes more transparent and fair.

The app is particularly useful in Kyrgyzstan, where rural areas often experience poor internet access and limited access to banking infrastructure. The ability to access the service offline via SMS or USSD makes it convenient even for those who can't regularly use the mobile app. Furthermore, its simple language and Kyrgyz language support help people better understand financial terms and make more informed decisions.

Thus, ClearLoan promotes financial literacy, reduces debt risks, promotes financial inclusion, and strengthens trust between citizens and the banking system. This makes the app beneficial not only for individual users but also for society as a whole, as it promotes a more sustainable and accessible financial environment in the country.

Progress of week 004:

- Simple registration upon login (where they ask for a phone number, password, and passport information (only during registration, not upon login))
- Footer: The first section will contain an aggregator, the second a "basket" of current loans, the third section where you enter the loan terms and the one you want, and the fourth section a profile where you can see your details, including your current employment status.
- At least some design and UI have been added, and in a red-green color scheme. Also, add a switcher where you can change the language (either Russian or Kyrgyz).

Progress of week 005:
Slightly improved the overall UI. The color scheme was adjusted toward a brighter green-white fintech style, replacing the previous darker tone. Basic spacing, typography, and card components were cleaned up to make the interface look more structured, though the design is still relatively simple and not fully polished.

Added a loan type selector in the “Request” section. Users can now choose between several basic options (for example: mortgage, consumer loan, etc.). The logic behind recommendations remains prototype-level and does not yet reflect real scoring or approval systems.

Moved the language switcher to the main authentication screens (Login / Registration). Users can now toggle between Russian and Kyrgyz. Translation coverage is partial and mostly affects UI labels rather than full localization.

Extended the registration form. In addition to phone number, password, and passport details, users now must specify:

Occupation (what they work as)

Monthly income
These fields are currently stored but not yet deeply used in scoring logic.

Created a basic Django backend with a simple SQLite database. It supports:

User registration

User login

Basic storage of profile data

Simple loan offer endpoints
The backend is minimal and does not yet include advanced validation, encryption layers beyond Django defaults, or real banking integrations.

Implemented a simple bottom navigation footer with four sections:

Aggregator (loan offers list)

Loans (active loans overview)

Request (loan conditions form)

Profile (user information and logout)

Added light animations (page transitions and minor UI effects). These are basic Flutter animations and do not yet represent a fully production-ready motion system.


Progress of Week 006:

The overall structure of the ClearLoan application was significantly refined to better reflect the concept of a financial navigator rather than a simple loan comparison tool. The interface was visually unified across all main screens, improving consistency in typography, spacing, and component hierarchy. The design now follows a clearer green-white fintech style with improved readability and simplified visual elements. Navigation responsiveness and screen transitions were slightly optimized to provide smoother interaction, although animations remain lightweight and prototype-level.

The loan aggregator screen was expanded with additional Kyrgyzstan banks and microfinance institutions to better simulate a realistic financial marketplace. Loan cards were redesigned to present information in a clearer format, including provider name, loan amount, interest rate, repayment term, and dynamically generated decision status. Loan approval is no longer displayed automatically. Instead, the system now performs a basic internal analysis before assigning a result such as Approved, Alternative, or Rejected.

A prototype credit scoring logic was introduced on the backend side. The decision process now considers user-provided parameters such as occupation, monthly income, requested amount, and simulated credit history indicators. This scoring mechanism remains simplified but demonstrates how approval decisions could be generated instead of being hardcoded.

The Django backend was substantially improved. Database models were extended to support user credit history, loan applications, and analytical decision results. API endpoints were reorganized to better separate authentication, loan requests, and profile data management. The backend now stores historical loan interactions, enabling future expansion toward recommendation systems and approval probability estimation.

The Profile section was enhanced with a dedicated credit history module. Users can now view previously requested or active loans along with status information. For users without any prior credit activity, the section remains empty, reflecting realistic behavior rather than placeholder data. Basic visual reporting elements were added to represent financial activity trends in a simplified form.

Multilingual support was expanded to include three languages: English, Russian, and Kyrgyz. Core interface elements were translated consistently across authentication, navigation, and main workflow screens. Localization is implemented at UI level and prepared for future full internationalization.

The main aggregator screen now includes sponsor attribution displayed at the bottom of the interface, indicating Aiyl Bank as the supporting organization of the application concept. This element was integrated carefully to avoid disrupting usability while maintaining visual balance.

Loan request functionality was improved with clearer input structure and validation feedback. Users can now select loan purpose categories and receive recommendations generated through backend evaluation rather than static responses. The overall request flow better reflects a guided financial decision process.

Additional internal improvements were introduced, including cleaner API communication structure, improved state handling between screens, and preparation for future offline-friendly logic described in the technical specification. While the system remains an MVP prototype, it now demonstrates a more realistic interaction between frontend interface, backend analysis, and user financial data management.
