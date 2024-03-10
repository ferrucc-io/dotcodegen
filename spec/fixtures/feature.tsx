
import { IAlert } from 'core/types/Alert';
import Icon from 'core/design-system/components/Icon';
import { ListItem, Select, Text, Tooltip, UnorderedList } from '@chakra-ui/react';

const FREQUENCIES = [
  { value: "0", label: "Daily" },
  { value: "1", label: "Weekly" },
  { value: "2", label: "Monthly" },
];

function TooltipBody() {
  return (
    <div className="flex">
      <UnorderedList>
        <ListItem>Daily: Every weekday at 9am UTC</ListItem>
        <ListItem>Weekly: Every Monday at 9am UTC</ListItem>
        <ListItem>Monthly: Start of the month at 9am UTC</ListItem>
      </UnorderedList>
    </div>
  );
}

export const Frequency: React.FC<{
  alertChanges: IAlert;
  setAlertChanges: (alert: IAlert) => void;
}> = ({ setAlertChanges, alertChanges }) => {
  const handleFrequencyChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const value = parseInt(e.target.value, 10);
    setAlertChanges({
      ...alertChanges,
      frequency: value as 0 | 1 | 2,
    });
  };

  return (
    <div className="flex flex-col">
      <div className="flex gap-1">
        <Text mb={0} fontWeight="semibold">
          Frequency
        </Text>
        <Tooltip label={<TooltipBody />} placement="right">
          <div>
            <Icon iconType="icon" name="question-purple" />
          </div>
        </Tooltip>
      </div>
      <Text mb={2} fontSize="sm" color="gray.600">
        How frequently you wish to receive the graph
      </Text>
      <Select
        size="sm"
        width="200px"
        placeholder="Select frequency"
        value={alertChanges.frequency.toString()}
        onChange={handleFrequencyChange}
        data-testid="frequency-select"
      >
        {FREQUENCIES.map((f) => (
          <option
            key={f.value}
            value={f.value}
            data-testid={`alert-frequency-${f.label.toLowerCase()}-option`}
          >
            {f.label}
          </option>
        ))}
      </Select>
    </div>
  );
};
