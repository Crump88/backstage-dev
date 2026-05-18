
# IaC/CI-CD Maturity Assessment Questionnaire

## Purpose
This questionnaire identifies your organization's current Infrastructure as Code and CI/CD capabilities, maturity level, and organizational readiness for a developer portal. The insights will guide recommendations for process improvements, tooling optimization, and developer experience enhancements.

---

## SECTION 1: IaC TOOLING & PRACTICES

### 1.1 Infrastructure as Code Tools
**Question:** What Infrastructure as Code tools does your organization currently use? (Select all that apply)
- [ ] Terraform
- [ ] CloudFormation (AWS)
- [ ] ARM Templates (Azure)
- [ ] Bicep (Azure)
- [ ] Kubernetes manifests (YAML)
- [ ] Helm
- [ ] CDK (AWS/TypeScript)
- [ ] Pulumi
- [ ] Other: ___________

**Impact:** Identifies your IaC tool ecosystem. This shapes automation possibilities, integration strategies, and the learning curve for standardization. A fragmented toolset indicates need for tool rationalization or federation strategies before portal deployment.

---

### 1.2 IaC Adoption & Coverage
**Question:** What percentage of your infrastructure is currently defined as code? (Estimate by layer)
- Cloud infrastructure (compute, networking, storage): _____ %
- Kubernetes/Container orchestration: _____ %
- Application configuration (ConfigMaps, secrets): _____ %
- Database schema and configuration: _____ %

**Impact:** Reveals infrastructure maturity and what's still manual/undocumented. Low percentages indicate significant technical debt and deployment risk. Helps prioritize what to bring under code first before enabling self-service.

---

### 1.3 IaC Repository Organization
**Question:** How is your IaC code organized?
- [ ] Single monolithic repository for all infrastructure
- [ ] Separate repos per environment (dev, staging, prod)
- [ ] Separate repos per team/product
- [ ] Separate repos per infrastructure layer (networking, compute, etc.)
- [ ] Hybrid approach: ___________
- [ ] No clear structure / ad-hoc

**Impact:** Reveals code organization patterns, scalability challenges, and team autonomy level. Determines how a portal must navigate permissions, discovery, and deployment boundaries.

---

### 1.4 State Management (Terraform / Similar)
**Question:** How do you manage IaC state? (If applicable)
- [ ] Local state files
- [ ] Shared state backend (S3, Azure Storage, Terraform Cloud)
- [ ] Mixed approach (some local, some shared)
- [ ] Not applicable / unclear

**Impact:** State management approach directly impacts deployment safety, concurrency handling, and disaster recovery. Local/mixed state indicates risk and process immaturity that must be addressed before self-service portal.

---

### 1.5 IaC Versioning & Change History
**Question:** How do you track and review changes to infrastructure code?
- [ ] Full Git history with pull requests
- [ ] Version control but limited review process
- [ ] Manual documentation of changes
- [ ] No formal tracking
- [ ] Unclear

**Impact:** Indicates governance maturity, auditability, and rollback capability. PR-based workflows show organizational discipline; gaps here suggest need for process enforcement before enabling self-service.

---

### 1.6 IaC Testing Practices
**Question:** What types of testing do you perform on infrastructure code? (Select all that apply)
- [ ] Linting and syntax validation
- [ ] Security scanning (policies, compliance checks)
- [ ] Unit tests (infrastructure unit testing)
- [ ] Integration tests (test deployment to ephemeral environments)
- [ ] Policy as Code validation (Sentinel, OPA, etc.)
- [ ] Manual testing only
- [ ] No formal testing

**Impact:** Testing practices indicate confidence in deployments and ability to catch errors early. Limited testing correlates with deployment incidents and resistance to automation. This affects what safety guardrails the portal must enforce.

---

## SECTION 2: CI/CD PIPELINE MATURITY

### 2.1 CI/CD Tooling
**Question:** What CI/CD platforms does your organization use?
- [ ] GitHub Actions
- [ ] Azure DevOps Pipelines
- [ ] GitLab CI/CD
- [ ] Jenkins
- [ ] CircleCI / TravisCI
- [ ] AWS CodePipeline
- [ ] Other: ___________
- [ ] No centralized CI/CD system

**Impact:** Identifies your automation platform, which determines portal integration capabilities, available APIs, and deployment trigger mechanisms. Multiple platforms suggest standardization opportunity.

---

### 2.2 Deployment Automation Level
**Question:** How automated is your typical deployment process?
- [ ] Fully automated (code commit → production without manual approval)
- [ ] Mostly automated (automated testing/validation, manual approval gate)
- [ ] Partially automated (some manual handoffs between stages)
- [ ] Mostly manual (deployment engineers run scripts)
- [ ] Ad-hoc / varies by team

**Impact:** Automation level indicates deployment safety and developer productivity. Low automation suggests process bottlenecks and missed efficiency opportunities. High automation shows readiness for portal-driven deployments.

---

### 2.3 Deployment Frequency & Lead Time
**Question:** How often do you deploy infrastructure changes to production?
- [ ] Multiple times per day
- [ ] Daily
- [ ] Weekly
- [ ] Monthly or less frequently
- [ ] Varies significantly by team
- [ ] Unclear

**Question:** What is the average time from code commit to production deployment (for infrastructure)?
- [ ] < 1 hour
- [ ] 1-4 hours
- [ ] 4-24 hours
- [ ] 1-5 days
- [ ] > 5 days
- [ ] Varies significantly / unclear

**Impact:** Deployment cadence and lead time are key DORA metrics indicating organizational delivery capability. These expose process friction. Slower deployments suggest approval bottlenecks, testing gaps, or manual toil that a portal can streamline.

---

### 2.4 Environment Management
**Question:** How do you manage multiple environments (dev, staging, prod)?
- [ ] Identical IaC with environment-specific variables/parameters
- [ ] Separate IaC per environment with manual synchronization
- [ ] Environment differences are undocumented/ad-hoc
- [ ] We primarily use a single environment
- [ ] Mixed approach: ___________

**Impact:** Environment consistency practices affect reliability and prevent "it works in dev" surprises. Undocumented differences create troubleshooting overhead and limit self-service safety. Shapes how portal should present environment options.

---

### 2.5 Rollback & Disaster Recovery
**Question:** What is your typical rollback strategy for failed deployments?
- [ ] Automated rollback to previous infrastructure version
- [ ] Manual rollback using version control / state restoration
- [ ] Manual infrastructure reconfiguration
- [ ] Incident response team involvement required
- [ ] No formal rollback process / depends on situation

**Impact:** Rollback capability is critical for production safety. Manual, time-consuming rollbacks indicate operational risk and reluctance to automate. Portal must enforce clear rollback guardrails.

---

## SECTION 3: TEAM STRUCTURE & ORGANIZATION

### 3.1 IaC/Infrastructure Code Ownership
**Question:** Who owns and manages infrastructure code in your organization?
- [ ] Centralized infrastructure/platform team
- [ ] DevOps/SRE team embedded with product teams
- [ ] Distributed ownership per product team
- [ ] Individual engineers responsible for their own infrastructure
- [ ] Mixed model: ___________

**Impact:** Ownership model reveals organizational silos, potential bottlenecks, and readiness for self-service. Centralized teams may resist delegation; distributed models need coordination. Portal design must match your ownership model.

---

### 3.2 Team Skills & IaC Expertise
**Question:** How would you rate your organization's infrastructure-as-code skills?
- [ ] Advanced: Most engineers can write/modify IaC safely
- [ ] Intermediate: Core team is skilled; broader org requires guidance
- [ ] Beginner: Limited IaC expertise; heavy reliance on specialists
- [ ] We don't have dedicated IaC skills; still learning

**Question:** What percentage of your engineering organization can independently write and deploy infrastructure changes?
- _____ % of developers
- _____ % of platform/ops engineers

**Impact:** Skills assessment identifies training gaps and resistance points. Low skills indicate need for guardrails, templates, and guided workflows in portal. High skills suggest opportunity for self-service and reduced friction.

---

### 3.3 IaC Documentation & Knowledge Sharing
**Question:** How well is your IaC documented?
- [ ] Comprehensive: Code comments, architecture docs, runbooks, decision records
- [ ] Adequate: Code has comments and basic documentation
- [ ] Minimal: Code comments only
- [ ] Poor: Limited or outdated documentation
- [ ] We maintain tribal knowledge / informal docs

**Impact:** Documentation quality predicts onboarding time, incident response effectiveness, and ability to empower self-service. Poor documentation is often the hidden cost of infrastructure management and a blocker for portal adoption.

---

### 3.4 Cross-Team Collaboration
**Question:** How do cross-functional teams collaborate on infrastructure changes?
- [ ] Well-defined: Processes, approval gates, clear communication channels
- [ ] Ad-hoc: Mostly informal discussions and emails
- [ ] Siloed: Teams work independently with minimal coordination
- [ ] Unclear / inconsistent

**Impact:** Collaboration patterns reveal organizational communication health. Silos suggest need for portal as central coordination point. Ad-hoc processes indicate opportunity to formalize workflows.

---

## SECTION 4: GOVERNANCE, SECURITY & COMPLIANCE

### 4.1 Access Control & Authorization
**Question:** How do you control access to infrastructure modifications?
- [ ] Role-based access control (RBAC) with clear team assignments
- [ ] Resource-based policies / tagging for access
- [ ] Manual access requests and approvals
- [ ] Basic authentication only / limited access controls
- [ ] Mixed approach: ___________

**Impact:** Access control maturity determines security posture and audit compliance. Weak controls indicate governance gaps that must be addressed before self-service. Strong RBAC enables safe delegation.

---

### 4.2 Change Approval Process
**Question:** What approval process is required for infrastructure changes?
- [ ] Automated approval based on policies (tests passing, policy compliance)
- [ ] Single manual approval (technical lead, platform team)
- [ ] Multiple approvals (peer review + manager + compliance)
- [ ] Case-by-case decisions
- [ ] No formal approval process

**Impact:** Approval complexity indicates organizational risk tolerance and process maturity. Overly complex approvals become bottlenecks; missing approvals indicate governance gaps. Portal must enforce appropriate controls.

---

### 4.3 Compliance & Auditing
**Question:** What compliance requirements impact your infrastructure?
- [ ] SOC 2, ISO 27001
- [ ] HIPAA, PCI-DSS (healthcare/payments)
- [ ] GDPR, data residency
- [ ] FedRAMP, government/defense
- [ ] Industry-specific standards
- [ ] Internal governance policies only
- [ ] No formal compliance requirements

**Question:** How do you audit infrastructure changes and enforce compliance?
- [ ] Automated compliance scanning and policy enforcement
- [ ] Manual audits and reviews
- [ ] Third-party compliance assessments only
- [ ] Unclear compliance processes

**Impact:** Compliance requirements determine what guardrails, approval processes, and audit trails the portal must provide. Regulatory constraints may require additional safety mechanisms before enabling self-service.

---

### 4.4 Security Scanning & Policy as Code
**Question:** What security practices do you enforce on infrastructure code?
- [ ] Automated secrets scanning in code repositories
- [ ] Vulnerability scanning of infrastructure configurations
- [ ] Policy as Code enforcement (OPA, Sentinel, Checkov)
- [ ] Manual security reviews
- [ ] No formal security scanning
- [ ] Other: ___________

**Impact:** Security automation indicates maturity and risk management practices. Manual-only reviews are bottlenecks and miss coverage. Gaps suggest need to shift-left security into portal workflows.

---

### 4.5 Infrastructure Drift Detection
**Question:** Do you detect and respond to infrastructure drift (manual changes)?
- [ ] Automated drift detection with alerts
- [ ] Regular manual drift audits
- [ ] Occasional drift investigations when issues arise
- [ ] No formal drift detection

**Impact:** Drift indicates loss of IaC as source of truth. Lack of drift detection suggests configuration inconsistencies will accumulate, reducing reliability. Portal should help prevent drift through centralized deployments.

---

## SECTION 5: DEVELOPER EXPERIENCE & SELF-SERVICE

### 5.1 Self-Service Infrastructure Provisioning
**Question:** Can developers currently self-serve for common infrastructure needs?
- [ ] Yes: Developers can independently provision what they need within guardrails
- [ ] Partial: Developers can self-serve for some resources; others require team assistance
- [ ] Limited: Developers can submit requests; infrastructure team handles provisioning
- [ ] No: Developers cannot self-serve; all requests go through infrastructure team
- [ ] It varies by team / unclear

**Impact:** Self-service capability indicates developer autonomy and infrastructure team bandwidth. Lack of self-service is a productivity bottleneck and creates organizational silos. Key motivation for portal investment.

---

### 5.2 Infrastructure Provisioning Lead Time
**Question:** How long does it typically take to provision new infrastructure resources?
- [ ] < 15 minutes
- [ ] 15 minutes - 1 hour
- [ ] 1-4 hours
- [ ] 4-24 hours
- [ ] 1-5 days
- [ ] > 5 days

**Impact:** Lead time is a key productivity metric. Long provisioning times create project delays and frustration. Reveals bottlenecks (manual processes, approvals, lack of automation) that a portal can address.

---

### 5.3 Infrastructure Documentation & Discoverability
**Question:** How do developers discover and learn about available infrastructure options?
- [ ] Central developer portal with clear documentation
- [ ] Scattered documentation (wikis, Confluence, GitHub, email)
- [ ] Mostly tribal knowledge / asking colleagues
- [ ] Ad-hoc documentation / difficult to find
- [ ] No formal documentation

**Impact:** Poor discoverability forces developers to ask infrastructure teams for information, creating bottlenecks. Documentation fragmentation is cognitive overhead. Portal should centralize and surface infrastructure capabilities.

---

### 5.4 Infrastructure Templates & Automation
**Question:** Do you provide templates or automated workflows for common infrastructure patterns?
- [ ] Yes: Comprehensive templates for most common scenarios
- [ ] Partial: Templates for some common patterns
- [ ] Limited: Basic templates but developers often customize/start from scratch
- [ ] No: Developers build infrastructure from scratch each time
- [ ] We've discussed it but haven't implemented

**Impact:** Template availability prevents duplication and ensures best practices. Lack of templates indicates missed productivity opportunity and consistency risks. Portal should surface and enforce templates.

---

### 5.5 Common Pain Points
**Question:** What are the biggest pain points developers experience with infrastructure provisioning? (Rank top 3)
- [ ] Takes too long to get infrastructure
- [ ] Don't know what's available or how to ask for it
- [ ] Approval/change control process is slow
- [ ] Difficult to understand infrastructure requirements
- [ ] Inconsistent across teams
- [ ] Lack of examples or templates
- [ ] Limited access / over-protective controls
- [ ] Documentation is outdated or hard to find
- [ ] Other: ___________

**Impact:** Pain points directly indicate where portal will deliver value. Developer feedback shapes prioritization for portal features and workflows. Reveals if problem is process, documentation, tools, or culture.

---

## SECTION 6: MULTI-ENVIRONMENT & SCALE

### 6.1 Cloud Platforms & Multi-Cloud Strategy
**Question:** What cloud platform(s) do you use?
- [ ] AWS only
- [ ] Azure only
- [ ] GCP only
- [ ] Multi-cloud (primary + secondary)
- [ ] On-premises only
- [ ] Hybrid (on-prem + cloud)
- [ ] Multiple platforms per team

**Impact:** Cloud platform choices determine tooling, IaC language selection, and integration requirements. Multi-cloud complexity increases portal design complexity but improves portability. Affects recommendation strategy.

---

### 6.2 Number of Environments
**Question:** How many distinct infrastructure environments do you manage?
- Development: _____ (how many dev environments?)
- Staging/Pre-prod: _____ 
- Production: _____ (how many prod regions/accounts/clusters?)
- Other: _____

**Impact:** Environment count indicates management complexity. Many environments require sophisticated templating and parameter management in portal. Scale determines automation ROI.

---

### 6.3 Infrastructure Scale Metrics
**Question:** Approximate your current infrastructure scale:
- Number of cloud accounts/subscriptions: _____
- Number of resource groups/VPCs: _____
- Number of applications/services: _____
- Number of production clusters/deployments: _____

**Impact:** Scale reveals operational complexity and automation necessity. Large scale makes manual processes untenable and justifies self-service investment. Small scale may not warrant full portal complexity.

---

### 6.4 Multi-Region & Multi-Team Deployments
**Question:** How do you handle deployments across multiple regions or teams?
- [ ] Centralized deployment orchestration
- [ ] Each region/team deploys independently
- [ ] Mixed: some centralized, some distributed
- [ ] We don't have multi-region / multi-team complexity

**Impact:** Multi-region/team deployments require coordination mechanisms. Centralized approaches scale better but create bottlenecks. Portal design must accommodate complexity level.

---

## SECTION 7: CURRENT TOOLS & INTEGRATION CAPABILITIES

### 7.1 Existing Platforms & Integration Points
**Question:** What existing tools/platforms would a developer portal need to integrate with?
- [ ] CI/CD pipeline (GitHub Actions, Azure DevOps, Jenkins, etc.)
- [ ] Git repositories (GitHub, GitLab, Bitbucket)
- [ ] Cloud IAM / authentication (Azure AD, Okta, AWS IAM)
- [ ] Monitoring & observability (Datadog, New Relic, Prometheus, etc.)
- [ ] Ticketing / incident management (Jira, ServiceNow, PagerDuty)
- [ ] Secrets management (Vault, AWS Secrets Manager, Azure Key Vault)
- [ ] Service catalog / CMDB
- [ ] Artifact repositories (Container registries, package managers)
- [ ] Other: ___________

**Impact:** Integration requirements determine portal architecture, API requirements, and implementation complexity. More integrations = higher value but more dependencies and maintenance burden.

---

### 7.2 API & Automation Maturity
**Question:** How API-mature are your current tools?
- [ ] Most tools have well-documented REST/GraphQL APIs
- [ ] Many tools have APIs but documentation is inconsistent
- [ ] Limited API availability; relying on webhooks/file-based integrations
- [ ] Most interactions are manual / UI-based

**Impact:** API maturity determines portal extensibility and automation depth. Poor API surface limits integration options and increases custom development effort.

---

## SECTION 8: ORGANIZATIONAL READINESS

### 8.1 Leadership Alignment & Prioritization
**Question:** How aligned is leadership on infrastructure/DevOps transformation priorities?
- [ ] Highly aligned: Infrastructure modernization is a strategic priority
- [ ] Partially aligned: Some teams prioritize it; others don't
- [ ] Low alignment: Treated as operational cost, not strategic investment
- [ ] Leadership concerned with different priorities

**Impact:** Leadership alignment determines budget, staffing, and organizational commitment. Misalignment will doom portal adoption. Critical success factor.

---

### 8.2 Budget & Resource Availability
**Question:** What resources are available for IaC/CI-CD improvements?
- [ ] Dedicated platform engineering team (______ people)
- [ ] Shared resources / part-time allocation (______ people)
- [ ] Budget for tooling but not personnel
- [ ] Limited resources; doing best we can with current constraints
- [ ] This is unclear

**Impact:** Resource availability determines project scope and timeline. Under-resourced initiatives fail to deliver. Helps set realistic expectations for maturity timeline.

---

### 8.3 Change Adoption & Organizational Culture
**Question:** How would you characterize your organization's approach to process/tooling changes?
- [ ] Early adopters: Embrace new tools and processes quickly
- [ ] Cautious but willing: Will adopt if benefits are clear
- [ ] Resistant: Prefer status quo; change is slow
- [ ] Mixed across teams

**Impact:** Cultural readiness predicts portal adoption success. Resistant organizations need more change management, communication, and incentive alignment.

---

### 8.4 Maturity Self-Assessment
**Question:** How would you rate your overall IaC/CI-CD maturity today?
- [ ] Level 1 (Chaotic): Manual processes, inconsistent practices, frequent incidents
- [ ] Level 2 (Reactive): Some automation; reactive incident response; inconsistent
- [ ] Level 3 (Managed): Documented processes, consistent automation, proactive monitoring
- [ ] Level 4 (Optimized): Continuous improvement, high automation, predictable outcomes
- [ ] Level 5 (Excellence): Industry-leading practices, full self-service, zero-trust automation

**Impact:** Self-assessment provides baseline for roadmap. Most organizations self-rate higher than objective assessment. Compare with other answers to identify gaps and misalignment.

---

## SECTION 9: DEVELOPER PORTAL CONTEXT

### 9.1 Developer Portal Vision
**Question:** What is the primary goal for your developer portal?
- [ ] Enable self-service infrastructure provisioning
- [ ] Improve developer onboarding
- [ ] Centralize IaC/deployment documentation
- [ ] Standardize infrastructure patterns across teams
- [ ] Improve visibility into services and dependencies
- [ ] Enforce compliance and governance
- [ ] Reduce toil in infrastructure management
- [ ] Other: ___________

**Impact:** Portal vision alignment ensures recommendations address your actual needs. Misaligned expectations lead to feature creep or disappointment.

---

### 9.2 Planned Portal Scope
**Question:** What capabilities should the developer portal include? (Rank by priority: 1-High, 2-Medium, 3-Low)
- [ ] Infrastructure provisioning templates & workflows
- [ ] Deployment pipeline orchestration
- [ ] Service catalog & dependency visualization
- [ ] Infrastructure documentation & runbooks
- [ ] Compliance & audit dashboard
- [ ] Cost visibility & chargeback
- [ ] Secrets and credentials management
- [ ] Monitoring & observability integration
- [ ] Incident response workflows
- [ ] Other: ___________

**Impact:** Scope clarification prevents over-engineering. Prioritization reveals what will drive adoption and ROI. Informs recommendation phasing.

---

### 9.3 Adoption Strategy
**Question:** How do you plan to rollout the developer portal?
- [ ] Pilot with one team, then expand
- [ ] Gradual rollout across all teams simultaneously
- [ ] Big bang: Full rollout to entire organization
- [ ] Unclear / still planning

**Impact:** Rollout strategy determines pilot scope for recommendations. Phased approaches reduce risk but extend ROI timeline. Affects change management requirements.

---

## SCORING MATRIX & MATURITY ASSESSMENT

### Maturity Levels Framework

| Level | Description | IaC State | CI/CD State | Governance | Self-Service |
|-------|-------------|-----------|-------------|------------|--------------|
| **1: Initial** | Ad-hoc, manual, reactive | <30% coverage, no testing | Manual deployments, no automation | Minimal controls | Developer request → team acts |
| **2: Repeatable** | Some standardization, emerging automation | 30-60% coverage, basic testing | Partial automation, manual gates | Basic access controls | Templates exist but inconsistent |
| **3: Defined** | Documented processes, consistent automation | 60-85% coverage, comprehensive testing | Mostly automated, clear approvals | RBAC in place, audit logging | Self-service with guardrails |
| **4: Managed** | Quantified metrics, continuous improvement | >85% coverage, policy as code | Full automation, <1 day lead time | Compliance automation, drift detection | Self-service for most use cases |
| **5: Optimized** | Autonomous, predictable, zero-trust | 100% coverage, all validation automated | Fully autonomous, <1 hour lead time | Real-time compliance, zero drift | Complete self-service platform |

---

## NEXT STEPS: ANALYSIS & RECOMMENDATIONS

Once questionnaire is completed:

1. **Current State Assessment**: Map responses to maturity levels
2. **Gap Analysis**: Identify capabilities blocking next maturity level
3. **Prioritized Roadmap**: Sequence improvements for maximum ROI
4. **Portal Readiness Review**: Assess whether organization is ready for portal (typically Level 3+ required)
5. **Recommendation Themes**:
   - Process improvements (governance, approval workflows)
   - Tooling optimization (IaC standardization, CI/CD maturity)
   - Team/cultural changes (skills, ownership, collaboration)
   - Developer experience (templates, documentation, self-service)

---

## QUESTIONNAIRE COMPLETION GUIDANCE

**Time Estimate:** 45-60 minutes

**Recommended Participants:**
- Infrastructure/Platform team lead
- DevOps/SRE representative
- One software engineering team lead
- Security/compliance representative (if applicable)
- IT operations or CTO

**Facilitation Tips:**
- Conduct in group session or individual interviews, then synthesize
- Ask follow-up probes: "Why?" "What barriers?" "What would improve this?"
- Note areas of disagreement between respondents (indicates communication gaps)
- Capture quotes about pain points for stakeholder interviews
