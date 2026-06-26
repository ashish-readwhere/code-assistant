import { SecondaryButton } from "../..";

export function OnboardingCardLanding({
  onSelectConfigure,
  isDialog,
}: {
  onSelectConfigure: () => void;
  isDialog?: boolean;
}) {
  return (
    <div className="xs:px-0 max-full flex w-full flex-col items-center justify-center px-4 text-center">
      <div className="xs:flex mb-2 hidden">
        <h2 className="text-2xl font-bold">Code Assistant</h2>
      </div>

      <p className="mb-5 mt-0 w-full text-sm">
        Get started with AI-powered coding by configuring your models
      </p>

      <SecondaryButton onClick={onSelectConfigure} className="w-full">
        Configure your models
      </SecondaryButton>
    </div>
  );
}
